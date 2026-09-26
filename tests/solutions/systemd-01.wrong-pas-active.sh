#!/usr/bin/env bash
# Réparé et démarré, mais pas activé : il ne reviendra pas après un redémarrage.
set -euo pipefail
unit=/etc/systemd/system/facturation-api.service
sed -i -e 's|^User=.*|User=facturation|' -e 's|^ExecStart=.*|ExecStart=/usr/local/bin/facturation-api|' "$unit"
systemctl daemon-reload
systemctl restart facturation-api
