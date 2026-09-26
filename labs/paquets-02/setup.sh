#!/usr/bin/env bash
# Casse : des fichiers installés par le paquet facturation-agent ont été
# supprimés ou modifiés à la main.
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"
# shellcheck source=../../lib/depot.sh
source "$RC_LIB/depot.sh"

depot_nettoyer
depot_paquet 2.1
depot_publier
depot_configurer
dpkg -i "$DEPOT/facturation-agent_2.1_all.deb" >/dev/null

rm -f /usr/bin/facturation-agent
echo "modèle modifié à la main pour un essai" >> /usr/share/facturation-agent/modeles/facture.tpl
