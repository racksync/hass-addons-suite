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
SERVER_ALIVE_INTERVAL=$(jq --raw-output ".server_alive_interval // 30" $CONFIG_PATH)
SERVER_ALIVE_COUNT_MAX=$(jq --raw-output ".server_alive_count_max // 3" $CONFIG_PATH)
MONITORING_PORT=$(jq --raw-output ".monitoring_port // 20000" $CONFIG_PATH)
LOG_LEVEL=$(jq --raw-output ".log_level // \"info\"" $CONFIG_PATH)

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

# This is now just the entrypoint that runs setup
bashio::log.info "Running autossh add-on setup..."

# Execute setup
exec /setup.sh