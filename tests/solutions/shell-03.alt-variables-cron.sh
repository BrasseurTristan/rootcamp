#!/usr/bin/env bash
# Variables PATH (entre guillemets) et SHELL définies dans le fichier cron :
# cron retire les guillemets et lance la commande avec bash, donc « &>> » marche.
set -euo pipefail
chmod +x /usr/local/bin/sauvegarde-compta
cat > /etc/cron.d/sauvegarde-compta <<'CRON'
SHELL=/bin/bash
PATH="/usr/local/bin:/usr/bin:/bin"
# Sauvegarde nocturne du dossier de la compta
30 2 * * * root sauvegarde-compta &>> /var/log/sauvegarde-compta.log
CRON
