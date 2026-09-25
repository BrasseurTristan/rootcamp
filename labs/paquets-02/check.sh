#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"
# shellcheck source=../../lib/depot.sh
source "$RC_LIB/depot.sh"

if [[ -n $(depot_version_installee) ]]; then
  ok "le paquet facturation-agent est installé"
else
  ko "le paquet facturation-agent est installé"
fi
if [[ -z $(dpkg --verify facturation-agent 2>&1) ]]; then
  ok "tous les fichiers du paquet sont présents et intacts"
else
  ko "tous les fichiers du paquet sont présents et intacts"
fi
expect_ok "la commande facturation-agent fonctionne" facturation-agent

rc_result
