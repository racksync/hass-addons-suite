#!/bin/bash

# Unified logging function - all types use the same format
log_message() {
    local level="$1"
    local message="$2"
    local timestamp=$(get_timestamp)
    echo "[$timestamp] [$level] $message"
}

# All log types use the same underlying function
log_info() {
    log_message "INFO" "$1"
}

log_success() {
    log_message "OK" "$1"
}

log_warning() {
    log_message "WARN" "$1"
}

log_error() {
    log_message "ERROR" "$1"
}

log_debug() {
    # Check for multiple ways debug might be enabled
    if [ "${DEBUG:-false}" = "true" ] || [ "${DEBUG:-false}" = "1" ] || [ "${DEBUG_LOGGING:-false}" = "true" ]; then
        # Debug the timezone being used (only show once)
        if [ "${DEBUG_TIMEZONE_SHOWN:-false}" != "true" ]; then
            echo "DEBUG: Using timezone: ${USER_TIMEZONE:-UTC} (USER_TIMEZONE=${USER_TIMEZONE:-notset})" >&2
            export DEBUG_TIMEZONE_SHOWN="true"
        fi
        log_message "DEBUG" "$1"
    fi
}

log_config() {
    log_message "CONFIG" "$1"
}

log_network() {
    log_message "NETWORK" "$1"
}

log_import() {
    log_message "IMPORT" "$1"
}

log_start() {
    log_message "START" "$1"
}

# Get user-friendly timestamp with timezone from config
get_timestamp() {
    # Use the global timezone variable that's always accessible
    # Fallback to UTC if not set
    TZ="${USER_TIMEZONE:-UTC}" date '+%Y-%m-%d %H:%M:%S'
}

# Separator function
log_separator() {
    echo "------------------------------------------------------------"
}

# Timestamped separator for major sections
log_section() {
    local timestamp=$(get_timestamp)
    echo ""
    echo "------------------------------------------------------------"
    echo "$timestamp"
    echo "------------------------------------------------------------"
    echo ""
}

# Header function
log_header() {
    echo ""
    log_separator
    echo "n8n Home Assistant Add-on"
    echo "Version: $(jq -r '.version // "unknown"' /data/options.json)"
    echo "Container: $(hostname)"
    echo "Started: $(get_timestamp)"
    log_separator
    echo ""
}

export N8N_SECURE_COOKIE=false
export N8N_HIRING_BANNER_ENABLED=false
export N8N_PERSONALIZATION_ENABLED=false
export N8N_VERSION_NOTIFICATIONS_ENABLED=false
export N8N_RUNNERS_ENABLED=true
export N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true

CONFIG_PATH="/data/options.json"
export GENERIC_TIMEZONE="$(jq --raw-output '.timezone // empty' $CONFIG_PATH)"

# Set system timezone for add-on logs only
if [ -n "${GENERIC_TIMEZONE}" ]; then
    export TZ="${GENERIC_TIMEZONE}"
else
    export TZ="UTC"
fi

# Store timezone in a global variable that's always accessible
USER_TIMEZONE="${GENERIC_TIMEZONE:-UTC}"
export USER_TIMEZONE

log_config "System timezone set to: ${TZ} (for add-on logs only)"

# NEW: Extract new environment variables from options
export N8N_HOST="$(jq --raw-output '.n8n_host // "127.0.0.1"' $CONFIG_PATH)"
export N8N_PORT="$(jq --raw-output '.n8n_port // 5678' $CONFIG_PATH)"
export N8N_PROTOCOL="$(jq --raw-output '.n8n_protocol // "http"' $CONFIG_PATH)"
export WEBHOOK_URL="$(jq --raw-output '.webhook_url // empty' $CONFIG_PATH)"
export N8N_EDITOR_BASE_URL="$(jq --raw-output '.n8n_editor_base_url // empty' $CONFIG_PATH)"
export N8N_PATH="$(jq --raw-output '.n8n_path // "/"' $CONFIG_PATH)"
export N8N_METRICS="$(jq --raw-output '.n8n_metrics // "false"' $CONFIG_PATH)"
export N8N_LOG_LEVEL="$(jq --raw-output '.n8n_log_level // "info"' $CONFIG_PATH)"

# Configure webhook port for n8n (internal port 5678, proxied through nginx on 7123)
export N8N_WEBHOOK_URL="${WEBHOOK_URL:-"http://127.0.0.1:7123"}"

# SSL Certificate Configuration (SECURE)
export N8N_SSL_CERT="/ssl/$(jq --raw-output '.certfile // empty' $CONFIG_PATH)"
export N8N_SSL_KEY="/ssl/$(jq --raw-output '.keyfile // empty' $CONFIG_PATH)"
export N8N_CMD_LINE="$(jq --raw-output '.cmd_line_args // empty' $CONFIG_PATH)"

# Configure SSL based on protocol and certificate availability
if [ "$N8N_PROTOCOL" = "https" ] && [ -f "$N8N_SSL_CERT" ] && [ -f "$N8N_SSL_KEY" ]; then
  log_success "SSL enabled with Home Assistant certificates"
  log_config "  SSL Certificate: $N8N_SSL_CERT"
  log_config "  SSL Key: $N8N_SSL_KEY"
elif [ "$N8N_PROTOCOL" = "https" ]; then
  log_warning "HTTPS protocol specified but SSL certificates not found"
  log_warning "Please configure SSL certificates in Home Assistant"
  log_warning "Falling back to HTTP for security"
  export N8N_PROTOCOL="http"
else
  log_info "HTTP protocol - SSL not required"
fi

#####################
## USER PARAMETERS ##
#####################

# REQUIRED

# Extract the values from env_vars_list
values=$(jq -r '.env_vars_list | .[]' "$CONFIG_PATH")

# Convert the values to an array
IFS=$'\n' read -r -d '' -a array <<< "$values"

# Show header
log_header

# Export keys and values
for element in "${array[@]}"
do
    key="${element%%:*}"
    value="${element#*:}"
    value=$(echo "$value" | xargs) # Remove leading and trailing whitespace
    export "$key"="$value"
    log_config "Environment variable: ${key}=${value}"
done

# IF NODE_FUNCTION_ALLOW_EXTERNAL is set, install the required packages

if [ -n "${NODE_FUNCTION_ALLOW_EXTERNAL}" ]; then
    log_info "Installing external npm packages..."
    IFS=',' read -r -a packages <<< "${NODE_FUNCTION_ALLOW_EXTERNAL}"
    for package in "${packages[@]}"
    do
        log_config "Installing package: ${package}..."
        npm install -g "${package}" && log_success "Successfully installed ${package}" || log_error "Failed to install ${package}"
    done
fi

DATA_DIRECTORY_PATH="/data/n8n"

mkdir -p "${DATA_DIRECTORY_PATH}/.n8n/.cache"

export N8N_USER_FOLDER="${DATA_DIRECTORY_PATH}"
log_config "n8n data directory: ${N8N_USER_FOLDER}"

log_network "Connecting to Home Assistant Supervisor..."
INFO=$(curl -s -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" http://supervisor/info)
INFO=${INFO:-'{}'}
log_debug "Supervisor info: ${INFO}"

CONFIG=$(curl -s -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" http://supervisor/core/api/config)
CONFIG=${CONFIG:-'{}'}
log_debug "Home Assistant config: ${CONFIG}"

ADDON_INFO=$(curl -s -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" http://supervisor/addons/self/info)
ADDON_INFO=${ADDON_INFO:-'{}'}
log_debug "Add-on info: ${ADDON_INFO}"

INGRESS_PATH=$(echo "$ADDON_INFO" | jq -r '.data.ingress_url // "/"')
INGRESS_ENTRY=$(echo "$ADDON_INFO" | jq -r '.data.ingress_entry // ""')
log_network "Ingress path configured: ${INGRESS_PATH}"
log_network "Ingress entry: ${INGRESS_ENTRY}"

# Set the correct base URL for n8n when running behind nginx
if [ -n "$N8N_EDITOR_BASE_URL" ]; then
  log_config "Using user-provided editor base URL: ${N8N_EDITOR_BASE_URL}"
else
  # Use the external URL for n8n when behind nginx reverse proxy
  EXTERNAL_URL=$(echo "$CONFIG" | jq -r '.external_url // empty')
  if [ -n "$EXTERNAL_URL" ]; then
    export N8N_EDITOR_BASE_URL="${EXTERNAL_URL}"
    log_config "Using Home Assistant external URL: ${N8N_EDITOR_BASE_URL}"
  else
    export N8N_EDITOR_BASE_URL="http://localhost:5678"
    log_config "Using default base URL: ${N8N_EDITOR_BASE_URL}"
  fi
fi

# Set the webhook URL for n8n when behind nginx
if [ -n "$WEBHOOK_URL" ]; then
  export N8N_WEBHOOK_URL="${WEBHOOK_URL}"
  log_config "Using user-provided webhook URL: ${N8N_WEBHOOK_URL}"
else
  # Use the external URL with port 7123 for webhooks
  EXTERNAL_URL=$(echo "$CONFIG" | jq -r '.external_url // empty')
  if [ -n "$EXTERNAL_URL" ]; then
    # Extract base URL and change port to 7123 for webhooks
    WEBHOOK_BASE=$(echo "$EXTERNAL_URL" | sed 's/:8123//;s/:80//;s/:443//')
    export N8N_WEBHOOK_URL="${WEBHOOK_BASE}:7123"
    log_config "Auto-detected webhook URL: ${N8N_WEBHOOK_URL}"
  else
    export N8N_WEBHOOK_URL="http://localhost:7123"
    log_config "Using default webhook URL: ${N8N_WEBHOOK_URL}"
  fi
fi

# Get the port from the configuration
LOCAL_HA_PORT=$(echo "$CONFIG" | jq -r '.port // "8123"')

# Get the Home Assistant hostname from the supervisor info
LOCAL_HA_HOSTNAME=$(echo "$INFO" | jq -r '.data.hostname // "localhost"')
LOCAL_N8N_URL="http://$LOCAL_HA_HOSTNAME:8765"
log_network "Local n8n URL: ${LOCAL_N8N_URL}"

# Get the external URL if configured, otherwise use the hostname and port
EXTERNAL_N8N_URL=${EXTERNAL_URL:-$(echo "$CONFIG" | jq -r ".external_url // \"$LOCAL_N8N_URL\"")}
EXTERNAL_HA_HOSTNAME=$(echo "$EXTERNAL_N8N_URL" | sed -e "s/https\?:\/\///" | cut -d':' -f1)
log_network "External n8n URL: ${EXTERNAL_N8N_URL}"

# Use configuration from config.yaml - read from user settings
log_separator
log_config "📋 N8N Configuration Parameters"
log_config "Host: $N8N_HOST (from n8n_host)"
log_config "Port: $N8N_PORT (from n8n_port)"
log_config "Protocol: $N8N_PROTOCOL (from n8n_protocol)"
log_info "Using user-provided configuration from add-on interface"

# Fix n8n deprecation warnings and proxy configuration
export DB_SQLITE_POOL_SIZE=10
export N8N_BLOCK_ENV_ACCESS_IN_NODE=false
export N8N_GIT_NODE_DISABLE_BARE_REPOS=true

# Express proxy configuration - use n8n-specific settings
export N8N_TRUST_PROXY=true
export N8N_PROXY_HOPS=1
export NODE_ENV=production

# Additional fixes for Home Assistant compatibility
# REMOVED: export NODE_TLS_REJECT_UNAUTHORIZED=0 (SECURITY: This disables SSL verification)
export N8N_SKIP_WEBHOOK_DEREGISTRATION_CHECK=true

log_config "🔧 Applied n8n Environments:"
log_config "  DB_SQLITE_POOL_SIZE=$DB_SQLITE_POOL_SIZE"
log_config "  N8N_BLOCK_ENV_ACCESS_IN_NODE=$N8N_BLOCK_ENV_ACCESS_IN_NODE"
log_config "  N8N_GIT_NODE_DISABLE_BARE_REPOS=$N8N_GIT_NODE_DISABLE_BARE_REPOS"
log_config "  N8N_TRUST_PROXY=$N8N_TRUST_PROXY (proxy trust)"
log_config "  N8N_PROXY_HOPS=$N8N_PROXY_HOPS (proxy hops)"
log_config "  NODE_ENV=$NODE_ENV"
log_config "  N8N_SKIP_WEBHOOK_DEREGISTRATION_CHECK=$N8N_SKIP_WEBHOOK_DEREGISTRATION_CHECK"
log_success "  SSL certificate verification enabled (SECURE)"

export WEBHOOK_URL=${WEBHOOK_URL:-"http://${LOCAL_HA_HOSTNAME}:7123"}

log_network "N8N Path: ${N8N_PATH:-"default"}"
log_network "Editor Base URL: ${N8N_EDITOR_BASE_URL:-"auto-detected"}"
log_network "Webhook URL: ${WEBHOOK_URL}"
log_config "N8N Log Level: ${N8N_LOG_LEVEL}"
log_config "Timezone: ${GENERIC_TIMEZONE:-UTC}"

###########
## MAIN  ##
###########

# First-run import logic
IMPORT_MARKER="/media/n8n_import.json"
CREDENTIALS_DIR="/config/n8n/credentials/"
WORKFLOWS_DIR="/config/n8n/workflows/"

if [ ! -f "$IMPORT_MARKER" ]; then
  log_import "First run detected: importing credentials and workflows..."

  log_section "Import Process Started"
  log_import "Beginning import process..."

  imported_credentials=()
  imported_workflows=()

  # Import credentials if directory exists and is not empty
  if [ -d "$CREDENTIALS_DIR" ] && [ "$(ls -A "$CREDENTIALS_DIR" 2>/dev/null)" ]; then
    log_import "Importing credentials from directory: $CREDENTIALS_DIR"
    n8n import:credentials --separate --input="$CREDENTIALS_DIR" && log_success "Credentials directory import completed" || log_error "Failed to import credentials from directory"
    for f in "$CREDENTIALS_DIR"*; do
      [ -f "$f" ] && imported_credentials+=("$(basename "$f")")
    done
  else
    log_info "No credentials directory found or directory is empty"
  fi

  # Import single credentials file if it exists
  SINGLE_CREDS_FILE="/config/n8n/creds.json"
  if [ -f "$SINGLE_CREDS_FILE" ]; then
    log_import "Importing credentials from file: $SINGLE_CREDS_FILE"
    n8n import:credentials --input="$SINGLE_CREDS_FILE" && log_success "Credentials file import completed" || log_error "Failed to import credentials file"
    imported_credentials+=("$(basename "$SINGLE_CREDS_FILE")")
  else
    log_info "No single credentials file found to import"
  fi

  # Import workflows if directory exists and is not empty
  if [ -d "$WORKFLOWS_DIR" ] && [ "$(ls -A "$WORKFLOWS_DIR" 2>/dev/null)" ]; then
    log_import "Importing workflows from directory: $WORKFLOWS_DIR"
    n8n import:workflow --separate --input="$WORKFLOWS_DIR" && log_success "Workflows directory import completed" || log_error "Failed to import workflows from directory"
    for f in "$WORKFLOWS_DIR"*; do
      [ -f "$f" ] && imported_workflows+=("$(basename "$f")")
    done
  else
    log_info "No workflows directory found or directory is empty"
  fi

  # Import single workflows file if it exists
  SINGLE_WORKFLOWS_FILE="/config/n8n/flows.json"
  if [ -f "$SINGLE_WORKFLOWS_FILE" ]; then
    echo "Importing workflows from $SINGLE_WORKFLOWS_FILE"
    n8n import:workflow --input="$SINGLE_WORKFLOWS_FILE"
    imported_workflows+=("$(basename "$SINGLE_WORKFLOWS_FILE")")
  else
    echo "No single workflows file to import."
  fi

  # Write import details to marker file in pretty JSON format using jq
  jq -n \
    --argjson workflows "$(printf '%s\n' "${imported_workflows[@]}" | jq -R . | jq -s .)" \
    --argjson credentials "$(printf '%s\n' "${imported_credentials[@]}" | jq -R . | jq -s .)" \
    --arg date "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" \
    '{imported_workflows: $workflows, imported_credentials: $credentials, import_date: $date}' > "$IMPORT_MARKER"
else
  log_info "Imports already performed on previous run - skipping"
fi

# Run n8n
log_section "Starting n8n workflow automation platform..."
log_start "Initializing n8n..."

# Show final configuration summary
log_info "Final Configuration:"
log_config "  User Folder: ${N8N_USER_FOLDER}"
log_config "  Webhook URL: ${WEBHOOK_URL}"
log_config "  Command Args: ${N8N_CMD_LINE:-"none"}"

log_section "n8n is launching..."
echo ""

if [ "$#" -gt 0 ]; then
  # Got started with arguments
  log_config "Launching n8n with custom arguments: ${N8N_CMD_LINE}"
  exec n8n "${N8N_CMD_LINE}"
else
  # Got started without arguments
  log_info "Launching n8n on port ${N8N_PORT}"
  exec n8n
fi