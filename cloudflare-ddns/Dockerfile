ARG BUILD_FROM
FROM $BUILD_FROM

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG BUILD_ARCH
env BUILD_ARCH $BUILD_ARCH

# Set the working directory inside the container
WORKDIR /app

# Set timezone
RUN apk --no-cache add tzdata \
    && ln -sf /usr/share/zoneinfo/Asia/Bangkok /etc/localtime \
    && echo "Asia/Bangkok" > /etc/timezone

# Install curl
RUN apk add --no-cache curl jq

COPY rootfs /
RUN chmod a+x -R /etc/

