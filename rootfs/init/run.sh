#!/bin/sh

set -e
set -x

if [ "${1:0:1}" = '-' ]
then
    set -- collectd "$@"
fi

if [ "$1" = 'collectd' ]
then
  /init/configure_collectd.sh "${@:2}"
fi

exec "$@"
