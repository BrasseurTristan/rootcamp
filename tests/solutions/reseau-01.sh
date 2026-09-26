#!/usr/bin/env bash
set -euo pipefail
sed -i 's/^ADRESSE=.*/ADRESSE=0.0.0.0/' /etc/intranet.conf
systemctl restart intranet
