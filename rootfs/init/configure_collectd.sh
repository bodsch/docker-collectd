#!/bin/bash

set -x
set -e

COLLECTD_HOST=${COLLECTD_HOST:-$(hostname -f)}
COLLECTD_INTERVAL=${COLLECTD_INTERVAL:-45}
GRAPHITE_HOST=${GRAPHITE_HOST:-}
GRAPHITE_PORT=${GRAPHITE_PORT:-2003}
GRAPHITE_PREFIX=${GRAPHITE_PREFIX:-"collectd."}

if [ -z ${GRAPHITE_HOST} ]
then
  echo "no GRAPHITE_HOST configured"
  exit 1
fi

configure() {

  [ -d /etc/collectd/collectd.d ] || mkdir /etc/collectd/collectd.d

  sed -i \
    -e "s|%COLLECTD_HOST%|${COLLECTD_HOST}|g" \
    -e "s|%COLLECTD_INTERVAL%|${COLLECTD_INTERVAL}|g" \
    -e "s|%GRAPHITE_HOST%|${GRAPHITE_HOST}|g" \
    -e "s|%GRAPHITE_PORT%|${GRAPHITE_PORT}|g" \
    -e "s|%GRAPHITE_PREFIX%|${GRAPHITE_PREFIX}|g" \
    /etc/collectd/collectd.conf

  collectd -t

  if [ $? -gt 0 ]
  then
    echo " [E] configuration not valid"
    exit 1
  fi
}

configure
