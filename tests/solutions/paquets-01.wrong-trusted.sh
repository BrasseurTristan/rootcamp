#!/usr/bin/env bash
# Le raccourci dangereux : désactiver la vérification de signature.
sed -i -e 's|^URIs:.*|URIs: file:/srv/depot-interne|' \
       -e 's|^Signed-By:.*|Trusted: yes|' \
       /etc/apt/sources.list.d/depot-interne.sources
apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq facturation-agent
