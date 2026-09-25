#!/usr/bin/env bash
# Répare les six pannes possibles, qu'elles soient actives ou non.
set -euo pipefail
hosts=$(grep -vw carnet.interne /etc/hosts)
printf '%s\n127.0.0.1       carnet.interne\n' "$hosts" > /etc/hosts
chown -R carnet:carnet /var/lib/carnet
chmod 750 /var/lib/carnet
sed -i 's|^ExecStart=.*|ExecStart=/opt/carnet/carnet.py|' /etc/systemd/system/carnet.service
systemctl daemon-reload
systemctl reset-failed carnet   # après trop d'échecs, systemd refuse de relancer
systemctl restart carnet
sed -i -e 's|proxy_pass http://127.0.0.1:[0-9]*;|proxy_pass http://127.0.0.1:5000;|' \
       -e 's|ssl_certificate_key .*|ssl_certificate_key /etc/ssl/carnet/carnet.key;|' /etc/nginx/sites-available/carnet
nginx -t -q
systemctl restart nginx
sed -i 's/tcp dport { 22, 80 } accept/tcp dport { 22, 80, 443 } accept/' /etc/nftables.conf
systemctl reset-failed nftables
systemctl restart nftables
sleep 1
