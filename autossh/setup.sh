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
FORCE_GENERATION=$(jq --raw-output ".force_keygen // false" $CONFIG_PATH)
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
  bashio::log.warning "Please restart add-on when done. Setup complete."
  # Create a flag to indicate setup is waiting for key
  touch /data/setup_waiting_for_key
  exit 0
else
  bashio::log.info "Authentication key pair restored from $KEY_PATH"
fi

bashio::log.info "Current public key(s):"
cat "${KEY_PATH}"/*.pub
bashio::log.info "Ensure these keys are added to '~/.ssh/authorized_keys' on your remote server"

if [ -z "$HOSTNAME" ]; then
  bashio::log.error "Please set 'hostname' in your config to the address of your remote server"
  bashio::log.error "Setup complete. Exiting..."
  touch /data/setup_failed
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
  touch /data/setup_failed
  exit 1
fi

# Setup complete flag
touch /data/setup_complete
bashio::log.info "Setup complete. Starting autossh service..."