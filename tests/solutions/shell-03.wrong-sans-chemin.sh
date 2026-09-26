#!/usr/bin/env bash
# Marche dans un terminal, mais pas avec le PATH de cron.
set -euo pipefail
chmod +x /usr/local/bin/sauvegarde-compta
cat > /etc/cron.d/sauvegarde-compta <<'CRON'
30 2 * * * root sauvegarde-compta >> /var/log/sauvegarde-compta.log 2>&1
CRON
