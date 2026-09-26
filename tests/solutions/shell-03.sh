#!/usr/bin/env bash
set -euo pipefail
chmod +x /usr/local/bin/sauvegarde-compta
cat > /etc/cron.d/sauvegarde-compta <<'CRON'
# Sauvegarde nocturne du dossier de la compta
30 2 * * * root /usr/local/bin/sauvegarde-compta >> /var/log/sauvegarde-compta.log 2>&1
CRON
