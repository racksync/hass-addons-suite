#!/bin/bash

# Set timezone environment variable early for all processes
CONFIG_PATH="/data/options.json"
GENERIC_TIMEZONE="$(jq --raw-output '.timezone // empty' $CONFIG_PATH)"

if [ -n "${GENERIC_TIMEZONE}" ]; then
    export TZ="${GENERIC_TIMEZONE}"
    export GENERIC_TIMEZONE="${GENERIC_TIMEZONE}"
else
    export TZ="UTC"
    export GENERIC_TIMEZONE="UTC"
fi

# Initialize directories and permissions
mkdir -p /run/nginx \
 && mkdir -p /var/log/supervisor \
 && mkdir -p /var/log/nginx \
 && chown -R nginx:nginx /var/log/nginx \
 && chown -R nginx:nginx /run/nginx

# Start supervisord with timezone properly set
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf