#!/bin/bash

ALPINE_BRANCH=${ALPINE_BRANCH:-3.10}
ALPINE_REPOSITORY=main
ALPINE_ARCH=x86_64

URL="http://dl-cdn.alpinelinux.org/alpine/v${ALPINE_BRANCH}/${ALPINE_REPOSITORY}/${ALPINE_ARCH}"

version=$(curl \
  --silent \
  --location \
  --retry 3 \
  "${URL}/APKINDEX.tar.gz" | \
  gunzip | \
  strings | \
  grep -A1 "P:collectd" | \
  tail -n1 | \
  cut -d ':' -f2 | \
  cut -d '-' -f1)

if [ -z "${version}" ]
then
  exit 1
fi

echo ${version}