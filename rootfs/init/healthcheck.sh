#!/bin/bash

pid=$(ps ax -o pid,args  | grep -v grep | grep collectd | awk '{print $1}')

config_file="${HOME}/collectd.conf"

if [[ $(echo -e "${pid}" | wc -w) -gt 0 ]]
then
  # test the configuration
  #
  collectd -C  "${config_file}" -t

  # validation are not successful
  #
  if [[ $? -gt 0 ]]
  then
    echo "the validation of our configuration was not successful."
    exit 1
  fi

  exit 0
fi

exit 2
