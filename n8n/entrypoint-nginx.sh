#!/bin/bash

# Wait for n8n to be ready before starting nginx
echo "Starting nginx reverse proxy for n8n..."

# Create supervisor log directory
mkdir -p /var/log/supervisor

# Generate nginx configuration based on environment variables
if [ -n "${NGINX_ALLOWED_IP}" ]; then
    echo "Configuring nginx IP restrictions for: ${NGINX_ALLOWED_IP}"
    # This would modify nginx.conf to include IP restrictions
fi

# Start supervisord to manage both nginx and n8n
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf