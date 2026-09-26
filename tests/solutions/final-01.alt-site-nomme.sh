#!/usr/bin/env bash
# Le site nginx est enregistré sous le nom « carnet.interne », avec
# default_server. Au lab suivant, rootcamp doit quand même le désactiver
# (régression : « duplicate default server » bloquait final-02 et les labs web).
set -euo pipefail
sed -e 's|sites-available/carnet\b|sites-available/carnet.interne|g' \
    -e 's|sites-enabled/carnet\b|sites-enabled/carnet.interne|g' \
    "$(dirname "$0")/final-01.sh" | bash
