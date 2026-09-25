#!/usr/bin/env bash
# Signé par la CA, mais le nom n'est que dans le CN : refusé par curl et les navigateurs.
mkdir -p /etc/ssl/compta
cd /etc/ssl/compta || exit 1
openssl req -new -newkey rsa:2048 -nodes -keyout compta.key -out compta.csr -subj "/CN=compta.interne" 2>/dev/null
openssl x509 -req -in compta.csr -days 365 -CA /srv/pki/ca.crt -CAkey /srv/pki/ca.key \
  -CAcreateserial -out compta.crt 2>/dev/null
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
