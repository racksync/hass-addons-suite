#!/bin/bash

export N8N_SECURE_COOKIE=false
export N8N_HIRING_BANNER_ENABLED=false
export N8N_PERSONALIZATION_ENABLED=false
export N8N_VERSION_NOTIFICATIONS_ENABLED=false
export N8N_RUNNERS_ENABLED=true
export N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true

CONFIG_PATH="/data/options.json"
export GENERIC_TIMEZONE="$(jq --raw-output '.timezone // empty' $CONFIG_PATH)"
export N8N_PROTOCOL="$(jq --raw-output '.protocol // empty' $CONFIG_PATH)"
export N8N_SSL_CERT="/ssl/$(jq --raw-output '.certfile // empty' $CONFIG_PATH)"
export N8N_SSL_KEY="/ssl/$(jq --raw-output '.keyfile // empty' $CONFIG_PATH)"
export N8N_CMD_LINE="$(jq --raw-output '.cmd_line_args // empty' $CONFIG_PATH)"

#####################
## USER PARAMETERS ##
#####################

# REQUIRED

# Extract the values from env_vars_list
values=$(jq -r '.env_vars_list | .[]' "$CONFIG_PATH")

# Convert the values to an array
IFS=$'\n' read -r -d '' -a array <<< "$values"

# Export keys and values
for element in "${array[@]}"
do
    key="${element%%:*}"
    value="${element#*:}"
    value=$(echo "$value" | xargs) # Remove leading and trailing whitespace
    export "$key"="$value"
    echo "exported ${key}=${value}"
done

# IF NODE_FUNCTION_ALLOW_EXTERNAL is set, install the required packages

if [ -n "${NODE_FUNCTION_ALLOW_EXTERNAL}" ]; then
    echo "Installing external packages..."
    IFS=',' read -r -a packages <<< "${NODE_FUNCTION_ALLOW_EXTERNAL}"
    for package in "${packages[@]}"
    do
        echo "Installing ${package}..."
        npm install -g "${package}"
    done
fi

DATA_DIRECTORY_PATH="/data/n8n"

mkdir -p "${DATA_DIRECTORY_PATH}/.n8n/.cache"

export N8N_USER_FOLDER="${DATA_DIRECTORY_PATH}"
echo "N8N_USER_FOLDER: ${N8N_USER_FOLDER}"

INFO=$(curl -s -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" http://supervisor/info)
INFO=${INFO:-'{}'}
echo "Fetched Info from Supervisor: ${INFO}"

CONFIG=$(curl -s -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" http://supervisor/core/api/config)
CONFIG=${CONFIG:-'{}'}
echo "Fetched Config from Supervisor: ${CONFIG}"

ADDON_INFO=$(curl -s -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" http://supervisor/addons/self/info)
ADDON_INFO=${ADDON_INFO:-'{}'}
echo "Fetched Add-on Info from Supervisor: ${ADDON_INFO}"

INGRESS_PATH=$(echo "$ADDON_INFO" | jq -r '.data.ingress_url // "/"')
echo "Extracted Ingress Path from Supervisor: ${INGRESS_PATH}"

# Get the port from the configuration
LOCAL_HA_PORT=$(echo "$CONFIG" | jq -r '.port // "8123"')

# Get the Home Assistant hostname from the supervisor info
LOCAL_HA_HOSTNAME=$(echo "$INFO" | jq -r '.data.hostname // "localhost"')
LOCAL_N8N_URL="http://$LOCAL_HA_HOSTNAME:8765"
echo "Local Home Assistant n8n URL: ${LOCAL_N8N_URL}"

# Get the external URL if configured, otherwise use the hostname and port
EXTERNAL_N8N_URL=${EXTERNAL_URL:-$(echo "$CONFIG" | jq -r ".external_url // \"$LOCAL_N8N_URL\"")}
EXTERNAL_HA_HOSTNAME=$(echo "$EXTERNAL_N8N_URL" | sed -e "s/https\?:\/\///" | cut -d':' -f1)
echo "External Home Assistant n8n URL: ${EXTERNAL_N8N_URL}"

export N8N_PATH=${N8N_PATH:-"${INGRESS_PATH}"}
export N8N_EDITOR_BASE_URL=${N8N_EDITOR_BASE_URL:-"${EXTERNAL_N8N_URL}${N8N_PATH}"}
export WEBHOOK_URL=${WEBHOOK_URL:-"http://${LOCAL_HA_HOSTNAME}:7123"}

echo "N8N_PATH: ${N8N_PATH}"
echo "N8N_EDITOR_BASE_URL: ${N8N_EDITOR_BASE_URL}"
echo "WEBHOOK_URL: ${WEBHOOK_URL}"

###########
## MAIN  ##
###########

# First-run import logic
IMPORT_MARKER="/media/n8n_import.json"
CREDENTIALS_DIR="/config/n8n/credentials/"
WORKFLOWS_DIR="/config/n8n/workflows/"

if [ ! -f "$IMPORT_MARKER" ]; then
  echo "First run detected: importing credentials and workflows..."

  imported_credentials=()
  imported_workflows=()

  # Import credentials if directory exists and is not empty
  if [ -d "$CREDENTIALS_DIR" ] && [ "$(ls -A "$CREDENTIALS_DIR" 2>/dev/null)" ]; then
    echo "Importing credentials from $CREDENTIALS_DIR"
    n8n import:credentials --separate --input="$CREDENTIALS_DIR"
    for f in "$CREDENTIALS_DIR"*; do
      [ -f "$f" ] && imported_credentials+=("$(basename "$f")")
    done
  else
    echo "No credentials to import from directory."
  fi

  # Import single credentials file if it exists
  SINGLE_CREDS_FILE="/config/n8n/creds.json"
  if [ -f "$SINGLE_CREDS_FILE" ]; then
    echo "Importing credentials from $SINGLE_CREDS_FILE"
    n8n import:credentials --input="$SINGLE_CREDS_FILE"
    imported_credentials+=("$(basename "$SINGLE_CREDS_FILE")")
  else
    echo "No single credentials file to import."
  fi

  # Import workflows if directory exists and is not empty
  if [ -d "$WORKFLOWS_DIR" ] && [ "$(ls -A "$WORKFLOWS_DIR" 2>/dev/null)" ]; then
    echo "Importing workflows from $WORKFLOWS_DIR"
    n8n import:workflow --separate --input="$WORKFLOWS_DIR"
    for f in "$WORKFLOWS_DIR"*; do
      [ -f "$f" ] && imported_workflows+=("$(basename "$f")")
    done
  else
    echo "No workflows to import from directory."
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
  echo "Imports already performed, skipping."
fi

# Run n8n

if [ "$#" -gt 0 ]; then
  # Got started with arguments
  exec n8n "${N8N_CMD_LINE}"
else
  # Got started without arguments
  exec n8n
fi