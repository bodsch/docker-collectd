#!/bin/bash

set -e
set -u

. /init/output.sh
. /etc/profile

COLLECTD_HOST=${COLLECTD_HOST:-$(hostname -f)}
COLLECTD_INTERVAL=${COLLECTD_INTERVAL:-45}

GRAPHITE_HOST=${GRAPHITE_HOST:-}
GRAPHITE_PORT=${GRAPHITE_PORT:-2003}
GRAPHITE_PREFIX=${GRAPHITE_PREFIX:-"collectd."}

COLLECT_D=$(command -v collectd)

if [ -z "${GRAPHITE_HOST}" ]
then
  echo "no GRAPHITE_HOST configured"
  exit 1
fi

if [ ! -f "${HOME}/collectd.conf" ]
then
  cp /etc/collectd/collectd.conf "${HOME}/"
fi

config_file="${HOME}/collectd.conf"


# side channel to inject some wild-style customized scripts
#
custom_scripts() {

  if [[ -d /init/custom.d ]]
  then
    for f in /init/custom.d/*
    do
      [ -e "${f}" ] || continue

      case "$f" in
        *.sh)
#          log_WARN "------------------------------------------------------"
#          log_WARN "RUN SCRIPT: ${f}"
#          log_WARN "YOU SHOULD KNOW WHAT YOU'RE DOING."
#          log_WARN "THIS CAN BREAK THE COMPLETE ICINGA2 CONFIGURATION!"
          nohup "${f}" > /proc/self/fd/2 2>&1 &
#          log_WARN "------------------------------------------------------"
          ;;
        *)
#          log_warn "ignoring file ${f}"
          ;;
      esac
      echo
    done
  fi
}

configure() {

  sed -i \
    -e "s|%COLLECTD_HOST%|${COLLECTD_HOST}|g" \
    -e "s|%COLLECTD_INTERVAL%|${COLLECTD_INTERVAL}|g" \
    -e "s|%GRAPHITE_HOST%|${GRAPHITE_HOST}|g" \
    -e "s|%GRAPHITE_PORT%|${GRAPHITE_PORT}|g" \
    -e "s|%GRAPHITE_PREFIX%|${GRAPHITE_PREFIX}|g" \
     "${config_file}"



  if ! collectd -C  "${config_file}" -t
  then
    log_error "configuration not valid"
    exit 1
  fi
}

custom_scripts




if [ "${1:0:1}" = '-' ]
then
  set -- "${COLLECT_D}" "$@"
fi

if [ "${1}" = 'collectd' ]
then
  configure
fi

exec "${@}" -C "${config_file}"
