#!/usr/bin/env bash
# « systemctl edit --full » : une copie complète de l'unité dans /etc, qui
# prend le pas sur celle du paquet (laissée intacte).
set -euo pipefail
sed 's|^ExecStart=.*|&\nRestart=on-failure|' /usr/lib/systemd/system/rapports.service \
  > /etc/systemd/system/rapports.service
systemctl daemon-reload
systemctl start rapports
