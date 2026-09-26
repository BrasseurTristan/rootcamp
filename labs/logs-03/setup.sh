#!/usr/bin/env bash
# Casse : le journal systemd n'est gardé qu'en mémoire (Storage=volatile) :
# tout est perdu à chaque redémarrage.
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"

mkdir -p /etc/systemd/journald.conf.d
rm -f /etc/systemd/journald.conf.d/*.conf
sed -i -E '/^[[:space:]]*(Storage|SystemMaxUse)[[:space:]]*=/d' /etc/systemd/journald.conf
cat > /etc/systemd/journald.conf.d/10-economie-disque.conf <<'CONF'
# Pour économiser le disque (ticket INFRA-812)
[Journal]
Storage=volatile
CONF
rm -rf /var/log/journal
# reset-failed : oublie les redémarrages trop rapprochés (limite de systemd)
systemctl reset-failed systemd-journald &>/dev/null || true
systemctl restart systemd-journald
