#!/usr/bin/env bash
set -euo pipefail
systemctl enable --now appli-commandes
sed -i 's|proxy_pass http://127.0.0.1:8000;|proxy_pass http://127.0.0.1:8081;\n        proxy_set_header Host $host;\n        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;|' /etc/nginx/sites-available/appli
nginx -t -q
systemctl reload nginx
sleep 1
