#!/bin/bash

curl \
  --silent \
  --location \
  --retry 3 \
  http://dl-cdn.alpinelinux.org/alpine/latest-stable/main/x86_64/APKINDEX.tar.gz | \
  gunzip | \
  strings | \
  grep -A1 "P:collectd" | \
  tail -n1 | \
  cut -d ':' -f2 | \
  cut -d '-' -f1
