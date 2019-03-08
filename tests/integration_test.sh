#!/bin/bash

inspect() {

  echo ""
  echo "inspect needed containers"
  for d in $(docker ps | tail -n +2 | awk  '{print($1)}')
  do
    # docker inspect --format "{{lower .Name}}" ${d}
    c=$(docker inspect --format '{{with .State}} {{$.Name}} has pid {{.Pid}} {{end}}' "${d}")
    s=$(docker inspect --format '{{json .State.Health }}' "${d}" | jq --raw-output .Status)

    printf "%-40s - %s\n"  "${c}" "${s}"
  done
}


running_containers=$(docker ps | tail -n +2  | wc -l)

if [[ ${running_containers} -eq 2 ]] || [[ ${running_containers} -gt 2 ]]
then
  inspect

  exit 0
else
  echo "the test setup needs minimum 2 containers"
  echo "only ${running_containers} running"
  echo "please run "
  echo " make compose-file"
  echo " docker-compose up --build -d"
  echo "before"
  echo "or check your system"

  exit 1
fi
