#!/usr/bin/env bash
# Le chemin est corrigé, mais la clé manque toujours : la signature échoue.
sed -i 's|^URIs:.*|URIs: file:/srv/depot-interne|' /etc/apt/sources.list.d/depot-interne.sources
apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq facturation-agent
