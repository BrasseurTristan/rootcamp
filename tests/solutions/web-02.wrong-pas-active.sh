#!/usr/bin/env bash
# L'appli est démarrée à la main, mais ne reviendra pas après un redémarrage.
systemctl start appli-commandes
sed -i 's|proxy_pass http://127.0.0.1:8000;|proxy_pass http://127.0.0.1:8081;\n        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;|' /etc/nginx/sites-available/appli
systemctl reload nginx
sleep 1
