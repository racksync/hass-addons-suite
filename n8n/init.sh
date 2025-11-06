#!/bin/bash

# Initialize directories and permissions
mkdir -p /run/nginx \
 && mkdir -p /var/log/supervisor \
 && mkdir -p /var/log/nginx \
 && chown -R nginx:nginx /var/log/nginx \
 && chown -R nginx:nginx /run/nginx

# Start supervisord
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf