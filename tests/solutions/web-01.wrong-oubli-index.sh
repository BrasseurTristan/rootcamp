#!/usr/bin/env bash
# Le site est au bon endroit, mais nginx ne trouve pas de page d'accueil : 403.
mkdir -p /var/www/compta
cp -r /home/alice/site-compta/. /var/www/compta/
sed -i 's|^\(\s*\)root .*|\1root /var/www/compta;|' /etc/nginx/sites-available/compta
systemctl reload nginx
