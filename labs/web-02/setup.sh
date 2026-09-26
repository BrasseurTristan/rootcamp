#!/usr/bin/env bash
# Casse : nginx relaie les requêtes vers l'application… sur le mauvais port,
# l'application est arrêtée, et nginx ne lui transmet pas l'adresse du client.
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"
# shellcheck source=../../lib/web.sh
source "$RC_LIB/web.sh"

systemctl disable --now appli-commandes &>/dev/null || true
cat > /usr/local/bin/appli-commandes <<'PY'
#!/usr/bin/env python3
"""Application des commandes (simulée) : répond sur 127.0.0.1:8081."""
from http.server import BaseHTTPRequestHandler, HTTPServer

class Appli(BaseHTTPRequestHandler):
    def do_GET(self):
        client = self.headers.get("X-Forwarded-For", "inconnu (pas d'en-tête X-Forwarded-For)")
        body = f"Appli des commandes\nclient : {client}\n".encode()
        self.send_response(200)
        self.send_header("Content-Type", "text/plain; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

HTTPServer(("127.0.0.1", 8081), Appli).serve_forever()
PY
chmod 755 /usr/local/bin/appli-commandes
cat > /etc/systemd/system/appli-commandes.service <<'UNIT'
[Unit]
Description=Application des commandes

[Service]
ExecStart=/usr/local/bin/appli-commandes
DynamicUser=yes

[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload

cat > /etc/nginx/sites-available/appli <<'CONF'
# nginx en frontal de l'application des commandes
server {
    listen 80 default_server;
    server_name _;

    access_log /var/log/nginx/appli.access.log;
    error_log  /var/log/nginx/appli.error.log;

    location / {
        proxy_pass http://127.0.0.1:8000;
    }
}
CONF
web_site appli
