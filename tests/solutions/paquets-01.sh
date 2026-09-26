#!/usr/bin/env bash
set -euo pipefail
cp /srv/depot-interne/cle-publique.asc /etc/apt/keyrings/depot-interne.asc
sed -i -e 's|^URIs:.*|URIs: file:/srv/depot-interne|' \
       -e 's|^Signed-By:.*|Signed-By: /etc/apt/keyrings/depot-interne.asc|' \
       /etc/apt/sources.list.d/depot-interne.sources
apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq facturation-agent
