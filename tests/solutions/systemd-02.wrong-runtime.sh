#!/usr/bin/env bash
# « systemctl edit --runtime » : la surcharge est dans /run, perdue au
# prochain redémarrage.
set -euo pipefail
mkdir -p /run/systemd/system/rapports.service.d
printf '[Service]\nRestart=on-failure\nRestartSec=2\n' > /run/systemd/system/rapports.service.d/override.conf
systemctl daemon-reload
systemctl start rapports
