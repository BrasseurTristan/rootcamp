#!/usr/bin/env bash
# Casse : la tâche cron de sauvegarde échoue sans laisser de trace utile.
#  - le script n'est pas exécutable
#  - la commande est appelée sans chemin, or cron a un PATH minimal
#  - « 2>&1 > log » n'envoie pas les erreurs dans le log
#  - « > » écrase le log à chaque exécution
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"

rm -f /var/log/sauvegarde-compta.log /var/backups/compta.tar.gz
mkdir -p /srv/compta /var/backups /etc/cron.d
echo "BILAN 2025" > /srv/compta/bilan-2025.txt

cat > /usr/local/bin/sauvegarde-compta <<'SCRIPT'
#!/bin/sh
# Sauvegarde le dossier de la compta dans /var/backups.
echo "$(date '+%F %T') sauvegarde de /srv/compta : début"
tar czf /var/backups/compta.tar.gz -C /srv compta
echo "$(date '+%F %T') avertissement : les fichiers temporaires sont ignorés" >&2
echo "$(date '+%F %T') sauvegarde de /srv/compta : terminée"
SCRIPT
chmod 644 /usr/local/bin/sauvegarde-compta

cat > /etc/cron.d/sauvegarde-compta <<'EOF2'
# Sauvegarde nocturne du dossier de la compta
30 2 * * * root sauvegarde-compta 2>&1 > /var/log/sauvegarde-compta.log
EOF2
chmod 644 /etc/cron.d/sauvegarde-compta
