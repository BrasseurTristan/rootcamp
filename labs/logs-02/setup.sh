#!/usr/bin/env bash
# Casse : la configuration logrotate de l'appli de facturation contient une
# erreur, le log n'a jamais été archivé et pèse 100 Mo. Et l'appli garde son
# fichier ouvert : une rotation naïve la ferait écrire dans le vide.
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"

systemctl stop facturation-journal &>/dev/null || true
systemctl reset-failed facturation-journal &>/dev/null || true
rm -rf /var/log/facturation-app
mkdir -p /var/log/facturation-app
fallocate -l 100M /var/log/facturation-app/app.log

cat > /usr/local/bin/facturation-journal <<'SCRIPT'
#!/bin/bash
# Application de facturation (simulée) : ouvre son log une seule fois, puis
# y écrit une ligne par seconde.
exec >> /var/log/facturation-app/app.log
while true; do
  echo "$(date '+%F %T') facture traitée n°$RANDOM"
  sleep 1
done
SCRIPT
chmod 755 /usr/local/bin/facturation-journal
cat > /etc/systemd/system/facturation-journal.service <<'UNIT'
[Unit]
Description=Application de facturation (journal)

[Service]
ExecStart=/usr/local/bin/facturation-journal
UNIT
systemctl daemon-reload
systemctl start facturation-journal

cat > /etc/logrotate.d/facturation-app <<'CONF'
# Rotation des logs de l'application de facturation
/var/log/facturation-app/*.log {
    daily
    rotate sept
    compress
    missingok
    notifempty
CONF
