
FROM alpine:3.7

MAINTAINER Bodo Schulz <bodo@boone-schulz.de>

ENV \
  TERM=xterm \
  BUILD_DATE="2017-12-08" \
  COLLECTD_VERSION="5.7.2"

LABEL \
  version="1712" \
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
    collectd-dns \
    collectd-mysql \
    collectd-nginx \
    collectd-network \
    collectd-write_redis \
    collectd-write_http \
    collectd-postgresql \
    collectd-sensors \
    collectd-lvm \
    collectd-virt \
    collectd-iptables \
    collectd-bind \
    collectd-redis \
    collectd-disk \
    collectd-ping \
    collectd-utils \
    collectd-curl && \
  mv /etc/collectd/collectd.conf /etc/collectd/collectd.conf-DIST && \
  rm -rf \
    /tmp/* \
    /var/cache/apk/*

COPY rootfs/ /

ENTRYPOINT ["/init/run.sh"]

CMD ["collectd","-f"]
