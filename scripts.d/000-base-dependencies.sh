#!/bin/bash

set -euo pipefail

DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y --no-install-recommends unminimize

sed -i -E 's/^(read .+ (\w+))$/\2=y  # \1/' $(which unminimize)
sed -i -E 's/^( *apt-get upgrade)$/\1 -y/' $(which unminimize)
unminimize

apt-get install -y --no-install-recommends \
  ubuntu-server-minimal \
  ubuntu-minimal \
  ubuntu-standard \
  unzip

apt-get remove -y --no-install-recommends unminimize
apt-get autoremove -y
