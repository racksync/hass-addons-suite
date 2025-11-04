#!/usr/bin/with-contenv bashio
set -e

# Configuration paths
CONFIG_PATH=/data/options.json
KEY_PATH=/data/ssh_keys
KNOWN_HOSTS_PATH=/data/.ssh/known_hosts

# Read configuration with defaults
HOSTNAME=$(jq --raw-output ".hostname // empty" $CONFIG_PATH)
SSH_PORT=$(jq --raw-output ".ssh_port // 22" $CONFIG_PATH)
USERNAME=$(jq --raw-output ".username // \"autossh\"" $CONFIG_PATH)
REMOTE_FORWARDING=$(jq --raw-output ".remote_forwarding[] // empty" $CONFIG_PATH)
LOCAL_FORWARDING=$(jq --raw-output ".local_forwarding[] // empty" $CONFIG_PATH)
OTHER_SSH_OPTIONS=$(jq --raw-output ".other_ssh_options // \"-v\"" $CONFIG_PATH)
FORCE_GENERATION=$(jq --raw-output ".force_keygen // false" $CONFIG_PATH)
SERVER_ALIVE_INTERVAL=$(jq --raw-output ".server_alive_interval // 30" $CONFIG_PATH)
SERVER_ALIVE_COUNT_MAX=$(jq --raw-output ".server_alive_count_max // 3" $CONFIG_PATH)
MONITORING_PORT=$(jq --raw-output ".monitoring_port // 20000" $CONFIG_PATH)
CONNECTION_ATTEMPTS=$(jq --raw-output ".connection_attempts // 3" $CONFIG_PATH)
LOG_LEVEL=$(jq --raw-output ".log_level // \"info\"" $CONFIG_PATH)
NOTE=$(jq --raw-output ".note // empty" $CONFIG_PATH)

# Enhanced logging based on log level
case "$LOG_LEVEL" in
  "debug")
    bashio::log.debug "Debug logging enabled"
    set -x
    ;;
  "error")
    bashio::log.error "Only error logging enabled"
    ;;
esac

bashio::log.info "Starting SSH Tunnel Services v2025.11.1"
bashio::log.info "Made with Love from Thailand, Bring to you by RACKSYNC 🇹🇭"

# Display user note if provided
if [ ! -z "$NOTE" ]; then
  bashio::log.info "Note: $NOTE"
fi

if [ "$FORCE_GENERATION" != "false" ]; then
  bashio::log.info "Deleting existing key pair due to set 'force_keygen'"
  bashio::log.warning "Do not forget to unset 'force_keygen' in your add-on configuration"
  rm -rf "$KEY_PATH"
fi

if [ ! -d "$KEY_PATH" ]; then
  bashio::log.info "No previous key pair found"
  mkdir -p "$KEY_PATH"
  # Use modern ED25519 keys instead of RSA for better security
  ssh-keygen -t ed25519 -N "" -C "hassio-autossh@$(date +%Y-%m-%d)" -f "${KEY_PATH}/autossh_key" || \
  ssh-keygen -b 4096 -t rsa -N "" -C "hassio-setup-via-autossh" -f "${KEY_PATH}/autossh_rsa_key"
  bashio::log.info "SSH key pair generated successfully"
  bashio::log.info "The public key is:"
  cat "${KEY_PATH}"/*.pub
  bashio::log.warning "Add this key to '~/.ssh/authorized_keys' on your remote server now!"
  bashio::log.warning "Please restart add-on when done. Exiting..."
  exit 1
else
  bashio::log.info "Authentication key pair restored from $KEY_PATH"
fi

bashio::log.info "Current public key(s):"
cat "${KEY_PATH}"/*.pub
bashio::log.info "Ensure these keys are added to '~/.ssh/authorized_keys' on your remote server"


if [ -z "$HOSTNAME" ]; then
  bashio::log.error "Please set 'hostname' in your config to the address of your remote server"
  exit 1
fi

# Create known_hosts directory
mkdir -p "$(dirname "$KNOWN_HOSTS_PATH")"

# Get remote host keys for security
bashio::log.info "Fetching remote server host keys..."
ssh-keyscan -p $SSH_PORT $HOSTNAME 2>/dev/null >> "$KNOWN_HOSTS_PATH" || \
  bashio::log.warning "Could not fetch host keys automatically"

# Test SSH connection with better error handling
bashio::log.info "Testing SSH connection to ${USERNAME}@${HOSTNAME}:${SSH_PORT}"

TEST_COMMAND="/usr/bin/ssh -T -o ConnectTimeout=10 -o BatchMode=yes -o StrictHostKeyChecking=yes \
  -o UserKnownHostsFile=$KNOWN_HOSTS_PATH -p ${SSH_PORT} ${USERNAME}@${HOSTNAME} 'echo connection_test' 2>&1 || true"

CONNECTION_RESULT=$(eval "${TEST_COMMAND}")

if echo "$CONNECTION_RESULT" | grep -q "connection_test"; then
  bashio::log.info "SSH connection test successful"
elif echo "$CONNECTION_RESULT" | grep -q "Permission denied"; then
  bashio::log.info "SSH service reachable, but authentication failed"
  bashio::log.info "Please ensure your SSH key is properly configured on the remote server"
else
  bashio::log.error "SSH connection test failed"
  bashio::log.error "Error details: $CONNECTION_RESULT"
  bashio::log.error "Please check hostname, port, and SSH key configuration"
  exit 1
fi

# Build autossh command with configuration
COMMAND="/usr/bin/autossh -M ${MONITORING_PORT} -N \
  -o ServerAliveInterval=${SERVER_ALIVE_INTERVAL} \
  -o ServerAliveCountMax=${SERVER_ALIVE_COUNT_MAX} \
  -o ExitOnForwardFailure=yes \
  -o StrictHostKeyChecking=yes \
  -o UserKnownHostsFile=$KNOWN_HOSTS_PATH \
  -o ConnectTimeout=10 \
  -p ${SSH_PORT} \
  -i ${KEY_PATH}/autossh_rsa_key \
  ${USERNAME}@${HOSTNAME}"

# Try to use ED25519 key if available, fallback to RSA
if [ -f "${KEY_PATH}/autossh_key" ]; then
  COMMAND="/usr/bin/autossh -M ${MONITORING_PORT} -N \
    -o ServerAliveInterval=${SERVER_ALIVE_INTERVAL} \
    -o ServerAliveCountMax=${SERVER_ALIVE_COUNT_MAX} \
    -o ExitOnForwardFailure=yes \
    -o StrictHostKeyChecking=yes \
    -o UserKnownHostsFile=$KNOWN_HOSTS_PATH \
    -o ConnectTimeout=10 \
    -p ${SSH_PORT} \
    -i ${KEY_PATH}/autossh_key \
    ${USERNAME}@${HOSTNAME}"
fi

# Function to validate forwarding format
validate_forwarding() {
  local forwarding="$1"
  local type="$2"

  # SSH forwarding format: [bind_address:]port:host:hostport
  # Examples:
  # - 127.0.0.1:3000:192.168.1.100:3000 (forward local 3000 to remote 192.168.1.100:3000)
  # - 3000:192.168.1.100:3000 (forward local 3000 to remote 192.168.1.100:3000)
  # - 127.0.0.1:3000:localhost:3000 (forward local 3000 to remote localhost:3000)

  if [[ -z "$forwarding" ]]; then
    return 0
  fi

  # Basic validation - should contain at least two colons
  if [[ ! "$forwarding" =~ :.*: ]]; then
    bashio::log.error "Bad ${type} forwarding specification '${forwarding}'"
    bashio::log.error "Expected format: [bind_address:]port:host:hostport"
    bashio::log.error "Example: 127.0.0.1:3000:192.168.1.100:3000"
    bashio::log.error "Example: 3000:localhost:3000"
    return 1
  fi

  # Count colons to ensure proper format
  local colon_count=$(echo "$forwarding" | tr -cd ':' | wc -c)
  if [[ $colon_count -lt 2 ]]; then
    bashio::log.error "Bad ${type} forwarding specification '${forwarding}'"
    bashio::log.error "Expected format: [bind_address:]port:host:hostport"
    bashio::log.error "Example: 127.0.0.1:3000:192.168.1.100:3000"
    bashio::log.error "Your specification has insufficient colon separators"
    return 1
  fi

  return 0
}

# Add remote forwarding rules
if [ ! -z "${REMOTE_FORWARDING}" ]; then
  while read -r LINE; do
    if [ ! -z "$LINE" ]; then
      if validate_forwarding "$LINE" "remote"; then
        COMMAND="${COMMAND} -R ${LINE}"
        bashio::log.info "Remote forwarding: ${LINE}"
      else
        bashio::log.error "Skipping invalid remote forwarding rule: ${LINE}"
        exit 1
      fi
    fi
  done <<< "${REMOTE_FORWARDING}"
fi

# Add local forwarding rules
if [ ! -z "${LOCAL_FORWARDING}" ]; then
  while read -r LINE; do
    if [ ! -z "$LINE" ]; then
      if validate_forwarding "$LINE" "local"; then
        COMMAND="${COMMAND} -L ${LINE}"
        bashio::log.info "Local forwarding: ${LINE}"
      else
        bashio::log.error "Skipping invalid local forwarding rule: ${LINE}"
        exit 1
      fi
    fi
  done <<< "${LOCAL_FORWARDING}"
fi

# Add additional SSH options
COMMAND="${COMMAND} ${OTHER_SSH_OPTIONS}"

bashio::log.info "Configuration summary:"
bashio::log.info "  Remote: ${USERNAME}@${HOSTNAME}:${SSH_PORT}"
bashio::log.info "  Monitoring port: ${MONITORING_PORT}"
bashio::log.info "  Server alive interval: ${SERVER_ALIVE_INTERVAL}s"
bashio::log.info "  Server alive count max: ${SERVER_ALIVE_COUNT_MAX}"
bashio::log.info "  Log level: ${LOG_LEVEL}"

bashio::log.info "Starting autossh tunnel..."
/usr/bin/autossh -V

# Execute the command
exec ${COMMAND}