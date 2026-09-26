#!/usr/bin/env bash
# L'épinglage déplacé sur la 2.2 : la mise à jour passe, mais la 2.3 sera
# bloquée à son tour.
set -euo pipefail
apt-mark unhold facturation-agent
sed -i 's/^Pin: version 2.1/Pin: version 2.2/' /etc/apt/preferences.d/facturation-agent
apt-get update -qq
apt-get install -y -qq facturation-agent >/dev/null
