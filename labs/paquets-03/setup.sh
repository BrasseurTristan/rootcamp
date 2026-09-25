#!/usr/bin/env bash
# Casse : facturation-agent est bloqué en version 2.1 de deux façons (hold et
# épinglage APT), alors que la 2.2 corrige une faille de sécurité.
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"
# shellcheck source=../../lib/depot.sh
source "$RC_LIB/depot.sh"

depot_nettoyer
depot_paquet 2.1
depot_paquet 2.2
depot_publier
depot_configurer
dpkg -i "$DEPOT/facturation-agent_2.1_all.deb" >/dev/null
apt-mark hold facturation-agent >/dev/null

cat > /etc/apt/preferences.d/facturation-agent <<'PREF'
# Bloqué en 2.1 pendant la migration de la compta (ticket INFRA-1234)
Package: facturation-agent
Pin: version 2.1
Pin-Priority: 1001
PREF
