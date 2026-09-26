#!/usr/bin/env bash
# Activé avec --runtime : le lien est dans /run, il disparaît au redémarrage.
set -euo pipefail
unit=/etc/systemd/system/facturation-api.service
sed -i -e 's|^User=.*|User=facturation|' -e 's|^ExecStart=.*|ExecStart=/usr/local/bin/facturation-api|' "$unit"
systemctl daemon-reload
systemctl enable --runtime --now facturation-api
systemctl restart facturation-api
