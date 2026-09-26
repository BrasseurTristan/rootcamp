#!/usr/bin/env bash
# Syntaxe corrigée, mais l'appli continue d'écrire dans l'ancien fichier.
cat > /etc/logrotate.d/facturation-app <<'CONF'
/var/log/facturation-app/*.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
}
CONF
logrotate -f /etc/logrotate.d/facturation-app
