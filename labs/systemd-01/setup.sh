#!/usr/bin/env bash
# Casse : l'unité systemd de l'API de facturation a deux erreurs (chemin du
# programme et nom de l'utilisateur) et n'est pas activée au démarrage.
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"

unit=/etc/systemd/system/facturation-api.service
systemctl disable --now facturation-api &>/dev/null || true
rm -rf "$unit" "$unit.d"

rc_user facturation

cat > /usr/local/bin/facturation-api <<'SCRIPT'
#!/bin/sh
# API de facturation (simulée) : écrit un « battement de cœur » toutes les 2 secondes.
echo "facturation-api : démarrage en tant que $(id -un)"
while true; do
  date '+%F %T' > /run/facturation/battement
  sleep 2
done
SCRIPT
chmod 755 /usr/local/bin/facturation-api

cat > "$unit" <<'UNIT'
[Unit]
Description=API de facturation
After=network.target

[Service]
User=factu
ExecStart=/usr/local/bin/facturation_api
RuntimeDirectory=facturation

[Install]
WantedBy=multi-user.target
UNIT

systemctl daemon-reload
systemctl reset-failed facturation-api &>/dev/null || true
systemctl start facturation-api &>/dev/null || true
