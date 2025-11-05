#!/bin/bash

# build the image
docker build \
    --build-arg NGINX_ALLOWED_IP=all \
    -t hass-n8n \
    .

# remove existing container
docker rm -f hass-n8n

# run the container
docker run \
    -p 8765:8765 \
    -p 5678:5678 \
    -p 7123:7123 \
    --name hass-n8n \
    hass-n8n