#!/usr/bin/env bash
# Le 502 est réglé, mais l'appli ne connaît toujours pas l'adresse du client.
systemctl enable --now appli-commandes
sed -i 's|proxy_pass http://127.0.0.1:8000;|proxy_pass http://127.0.0.1:8081;|' /etc/nginx/sites-available/appli
systemctl reload nginx
sleep 1
