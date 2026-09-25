#!/usr/bin/env bash
set -euo pipefail
cat > /etc/logrotate.d/facturation-app <<'CONF'
/var/log/facturation-app/*.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    copytruncate
}
CONF
logrotate -f /etc/logrotate.d/facturation-app
