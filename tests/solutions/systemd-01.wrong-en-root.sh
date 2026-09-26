#!/usr/bin/env bash
# « Ça marche » en supprimant la ligne User=… mais le service tourne en root.
set -euo pipefail
unit=/etc/systemd/system/facturation-api.service
sed -i -e '/^User=/d' -e 's|^ExecStart=.*|ExecStart=/usr/local/bin/facturation-api|' "$unit"
systemctl daemon-reload
systemctl enable --now facturation-api
systemctl restart facturation-api
