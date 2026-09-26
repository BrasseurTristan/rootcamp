#!/usr/bin/env bash
# Archives datées (dateext) plutôt que numérotées : app.log-AAAAMMJJ.gz.
set -euo pipefail
cat > /etc/logrotate.d/facturation-app <<'CONF'
/var/log/facturation-app/*.log {
    daily
    rotate 7
    compress
    dateext
    missingok
    notifempty
    copytruncate
}
CONF
