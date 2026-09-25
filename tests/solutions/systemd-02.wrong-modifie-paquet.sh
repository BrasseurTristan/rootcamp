#!/usr/bin/env bash
# Marche… jusqu'à la prochaine mise à jour du paquet, qui écrasera le fichier.
set -euo pipefail
sed -i 's|^ExecStart=.*|&\nRestart=on-failure|' /usr/lib/systemd/system/rapports.service
systemctl daemon-reload
systemctl start rapports
