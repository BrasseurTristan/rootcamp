#!/usr/bin/env bash
# Une vraie sauvegarde, mais pas la plus récente.
set -euo pipefail
mkdir -p /etc/facturation
cp /srv/sauvegardes/2025-05/etc/facturation/facturation.conf /etc/facturation/facturation.conf
