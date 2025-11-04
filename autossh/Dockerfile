ARG BUILD_FROM
FROM $BUILD_FROM

# Set environment variables
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=UTC

# Install packages with proper version pinning and cleanup
RUN apk add --no-cache \
    tzdata=2024b-r0 \
    jq=1.7.1-r0 \
    openssh-client=9.6_p1-r0 \
    curl=8.10.1-r0 \
    autossh=1.4g-r1 \
    && apk cache clean

# Create necessary directories
RUN mkdir -p /data/.ssh \
    && chmod 700 /data/.ssh

# Set timezone to UTC by default (can be overridden)
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime

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