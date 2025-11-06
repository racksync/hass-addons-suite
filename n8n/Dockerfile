FROM n8nio/n8n:stable

USER root
RUN apk add --no-cache --update \
    jq \
    bash \
    npm \
    curl \
    git \
    nginx \
    supervisor \
    envsubst

# Create required directories
RUN mkdir -p /run/nginx \
 && mkdir -p /var/log/supervisor \
 && mkdir -p /var/log/nginx

WORKDIR /data
COPY entrypoint-n8n.sh /app/entrypoint-n8n.sh
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY init.sh /app/init.sh

RUN chmod +x /app/entrypoint-n8n.sh \
 && chmod +x /app/init.sh

ENTRYPOINT ["/app/init.sh"]