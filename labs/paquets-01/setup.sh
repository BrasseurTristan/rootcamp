#!/usr/bin/env bash
# Casse : le dépôt interne est déclaré avec un mauvais chemin, et sa signature
# doit être vérifiée avec une clé qui n'a jamais été installée.
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"
# shellcheck source=../../lib/depot.sh
source "$RC_LIB/depot.sh"

depot_nettoyer
depot_paquet 2.1
depot_publier

cat > "$DEPOT_SOURCE" <<'SOURCE'
# Dépôt interne de l'entreprise
Types: deb
URIs: file:/srv/depot_interne
Suites: ./
Signed-By: /usr/share/keyrings/depot-interne.gpg
SOURCE
