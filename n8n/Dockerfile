FROM n8nio/n8n:stable

USER root
RUN apk add --no-cache --update \
    jq \
    bash \
    npm \
    curl \
    git

WORKDIR /data
COPY entrypoint-n8n.sh /app/entrypoint-n8n.sh

ENTRYPOINT ["/app/entrypoint-n8n.sh"]