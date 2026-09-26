#!/usr/bin/env bash
# Épinglage remplacé par une préférence pour tout le dépôt interne : les
# futures versions en viendront aussi, rien n'est bloqué.
set -euo pipefail
apt-mark unhold facturation-agent
cat > /etc/apt/preferences.d/facturation-agent <<'PREF'
Package: facturation-agent
Pin: release o=Interne
Pin-Priority: 990
PREF
apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq facturation-agent >/dev/null
