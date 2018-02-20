
FROM alpine:3.7

ENV \
  TERM=xterm \
  TZ='Europe/Berlin' \
  BUILD_DATE="2018-02-20" \
  COLLECTD_VERSION="5.7.2"

LABEL \
  version="1802" \
  maintainer="Bodo Schulz <bodo@boone-schulz.de>" \
  org.label-schema.build-date=${BUILD_DATE} \
  org.label-schema.name="Collectd Docker Image" \
  org.label-schema.description="Inofficial Collectd Docker Image" \
  org.label-schema.url="https://collectd.org" \
  org.label-schema.vcs-url="https://github.com/bodsch/docker-collectd" \
  org.label-schema.vendor="Bodo Schulz" \
  org.label-schema.version=${COLLECTD_VERSION} \
  org.label-schema.schema-version="1.0" \
  com.microscaling.docker.dockerfile="/Dockerfile" \
  com.microscaling.license="Unlicense"

# ---------------------------------------------------------------------------------------

COPY rootfs/ /

RUN \
  apk --quiet --no-cache update && \
  apk --quiet --no-cache upgrade && \
  echo 'hosts: files dns' >> /etc/nsswitch.conf && \
  apk --quiet --no-cache add \
    collectd \
    collectd-apache \
    collectd-bind \
    collectd-curl \
    collectd-disk \
    collectd-dns \
    collectd-iptables \
    collectd-lvm \
    collectd-mysql \
    collectd-network \
    collectd-nginx \
    collectd-ping \
    collectd-postgresql \
    collectd-python\
    collectd-redis \
    collectd-sensors \
    collectd-utils \
    collectd-virt \
    collectd-write_redis \
    collectd-write_http \
    tzdata && \
  cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
  echo ${TZ} > /etc/timezone && \
  mv /etc/collectd/collectd.conf /etc/collectd/collectd.conf-DIST && \
  rm -rf \
    /tmp/* \
    /var/cache/apk/*

COPY rootfs/ /

ENTRYPOINT ["/init/run.sh"]

CMD ["collectd","-f"]
