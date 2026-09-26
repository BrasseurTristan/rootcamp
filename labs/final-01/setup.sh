#!/usr/bin/env bash
# Prépare : le code de l'application « carnet » est livré, rien d'autre. Tout
# le reste (compte, service, HTTPS, pare-feu) est à construire.
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"
# shellcheck source=../../lib/reseau.sh
source "$RC_LIB/reseau.sh"
# shellcheck source=../../lib/web.sh
source "$RC_LIB/web.sh"
# shellcheck source=../../lib/carnet.sh
source "$RC_LIB/carnet.sh"

carnet_nettoyer
carnet_ca
carnet_appli
carnet_environnement
systemctl reload nginx &>/dev/null || true
