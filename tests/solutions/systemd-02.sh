#!/usr/bin/env bash
set -euo pipefail
mkdir -p /etc/systemd/system/rapports.service.d
printf '[Service]\nRestart=on-failure\nRestartSec=2\n' > /etc/systemd/system/rapports.service.d/override.conf
systemctl daemon-reload
systemctl start rapports
