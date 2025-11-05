#!/bin/bash

# Copy the nginx configuration to the final location
cp /etc/nginx/nginx.conf.template /etc/nginx/nginx.conf
/usr/sbin/nginx -g "daemon off;"