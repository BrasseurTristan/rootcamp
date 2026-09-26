#!/usr/bin/env bash
# Un certificat auto-signé : chiffré, mais aucun poste ne peut lui faire confiance.
mkdir -p /etc/ssl/compta
cd /etc/ssl/compta || exit 1
openssl req -x509 -newkey rsa:2048 -nodes -days 365 -keyout compta.key -out compta.crt \
  -subj "/CN=compta.interne" -addext "subjectAltName=DNS:compta.interne" 2>/dev/null
chmod 600 compta.key
cat > /etc/nginx/sites-available/compta-tls <<'CONF'
server {
    listen 443 ssl;
    server_name compta.interne;
    ssl_certificate     /etc/ssl/compta/compta.crt;
    ssl_certificate_key /etc/ssl/compta/compta.key;
    root /var/www/compta-tls;
}
server {
    listen 80 default_server;
    server_name compta.interne;
    return 301 https://$host$request_uri;
}
CONF
systemctl reload nginx
sleep 1
