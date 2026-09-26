#!/usr/bin/env bash
# Chemin complet, script exécutable, ajout… mais les erreurs ne vont toujours pas dans le log.
set -euo pipefail
chmod +x /usr/local/bin/sauvegarde-compta
cat > /etc/cron.d/sauvegarde-compta <<'CRON'
30 2 * * * root /usr/local/bin/sauvegarde-compta 2>&1 >> /var/log/sauvegarde-compta.log
CRON
