#!/usr/bin/env bash
# On utilise ce qui reste dans le groupe de volumes, sans ajouter le disque : pas assez.
set -euo pipefail
lvextend -q -r -l +100%FREE vg_donnees/postgres
