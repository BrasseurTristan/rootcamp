#!/usr/bin/env bash
# La bonne version… mais lisible par root seulement : « facturation » échoue
# pour tout le monde sauf root.
set -euo pipefail
install -d -m 700 /etc/facturation
install -m 600 /srv/sauvegardes/2025-06/etc/facturation/facturation.conf /etc/facturation/facturation.conf
