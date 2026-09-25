#!/usr/bin/env bash
set -euo pipefail
mkdir -p /var/www/compta
cp -r /home/alice/site-compta/. /var/www/compta/
mv /var/www/compta/accueil.html /var/www/compta/index.html
sed -i 's|^\(\s*\)root .*|\1root /var/www/compta;|' /etc/nginx/sites-available/compta
nginx -t -q
systemctl reload nginx
