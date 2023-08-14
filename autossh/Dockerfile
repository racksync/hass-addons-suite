ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

RUN apk add --no-cache tzdata jq openssh vim curl autossh \
    && ln -sf /usr/share/zoneinfo/Asia/Bangkok /etc/localtime \
    && echo "Asia/Bangkok" > /etc/timezone

WORKDIR /

COPY rootfs /

COPY run.sh /
RUN chmod a+x /run.sh
CMD [ "/run.sh" ]
WORKDIR /