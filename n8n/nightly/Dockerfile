FROM n8nio/n8n:nightly

ARG NGINX_ALLOWED_IP=172.30.32.2
ENV NGINX_ALLOWED_IP=${NGINX_ALLOWED_IP}

USER root
RUN apk add --no-cache --update \
    jq \
    bash \
    npm \
    curl \
    nginx \
    supervisor \
    envsubst \
    git

WORKDIR /data
COPY entrypoint-n8n.sh /app/entrypoint-n8n.sh

RUN mkdir -p /run/nginx

COPY nginx.conf /etc/nginx/nginx.conf.template

COPY entrypoint-n8n.sh /app/entrypoint-n8n.sh
COPY entrypoint-nginx.sh /app/entrypoint-nginx.sh

COPY nginx.conf /etc/nginx/nginx.conf
COPY supervised.conf /etc/supervised.conf


ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervised.conf"]