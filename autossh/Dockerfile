ARG BUILD_FROM
FROM $BUILD_FROM

# Set environment variables
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=UTC

# Install packages and setup basic configuration
RUN apk add --no-cache \
    tzdata \
    jq \
    openssh-client \
    curl \
    autossh \
    && apk cache clean \
    && mkdir -p /data/.ssh \
    && chmod 700 /data/.ssh \
    && ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# Copy application files
COPY rootfs/ /
COPY run.sh /run.sh

# Set proper permissions
RUN chmod +x /run.sh \
    && chmod 600 /data/.ssh/* 2>/dev/null || true

# Create non-root user for security (optional, commented out for HA compatibility)
# RUN addgroup -g 1000 autossh && adduser -D -s /bin/sh -u 1000 -G autossh autossh

# Set working directory
WORKDIR /

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD pgrep autossh > /dev/null || exit 1

# Set the entrypoint
CMD ["/run.sh"]