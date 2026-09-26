#!/usr/bin/env bash
# Tout marche… mais le port de débogage est exposé à tout le réseau.
set -euo pipefail
sed -n '1,/^# Le pare-feu/p' "$(dirname "$0")/final-01.sh" | bash
