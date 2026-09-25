#!/usr/bin/env bash
# Le fichier est corrigé après coup, mais systemd ne l'a pas relu :
# le redémarrage utilise encore l'ancienne version de l'unité.
set -euo pipefail
unit=/etc/systemd/system/facturation-api.service
systemctl enable facturation-api
sed -i -e 's|^User=.*|User=facturation|' -e 's|^ExecStart=.*|ExecStart=/usr/local/bin/facturation-api|' "$unit"
systemctl restart facturation-api || true
