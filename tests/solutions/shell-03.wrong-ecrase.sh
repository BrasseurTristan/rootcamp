#!/usr/bin/env bash
# Tout va dans le log… mais chaque nuit efface la précédente.
set -euo pipefail
chmod +x /usr/local/bin/sauvegarde-compta
cat > /etc/cron.d/sauvegarde-compta <<'CRON'
30 2 * * * root /usr/local/bin/sauvegarde-compta > /var/log/sauvegarde-compta.log 2>&1
CRON
