#!/usr/bin/env bash
# Solution correcte, vérifiée avec un terminal resté ouvert dans /srv/archives
# (le dossier est « occupé » : un démontage échouerait).
set -euo pipefail
bash "$(dirname "$0")/stockage-02.sh"
setsid timeout 15 sh -c 'cd /srv/archives && exec sleep 15' </dev/null >/dev/null 2>&1 &
sleep 0.5
