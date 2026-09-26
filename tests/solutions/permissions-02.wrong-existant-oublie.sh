#!/usr/bin/env bash
# Les futurs fichiers sont bons, mais l'existant n'a pas été corrigé.
set -euo pipefail
chmod g+s /srv/compta
setfacl -d -m g::rwx /srv/compta
