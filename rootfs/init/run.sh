#!/bin/sh

set -e

if [ -d /init/custom.d ]
then
  for f in /init/custom.d/*
  do
    case "$f" in
      *.sh)     echo "$0: running $f"; . "$f" ;;
      *)        echo "$0: ignoring $f" ;;
    esac
    echo
  done
fi

if [[ "${1:0:1}" = '-' ]]
then
  set -- collectd "$@"
fi

if [[ "$1" = 'collectd' ]]
then
  /init/configure_collectd.sh "${@:2}"
fi

exec "$@"
