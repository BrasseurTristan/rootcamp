#!/usr/bin/env bash
# HTTPS fonctionne, mais le site reste aussi accessible en HTTP.
mkdir -p /etc/ssl/compta
cd /etc/ssl/compta || exit 1
openssl req -new -newkey rsa:2048 -nodes -keyout compta.key -out compta.csr -subj "/CN=compta.interne" 2>/dev/null
echo "subjectAltName=DNS:compta.interne" > san.ext
openssl x509 -req -in compta.csr -days 365 -CA /srv/pki/ca.crt -CAkey /srv/pki/ca.key \
  -CAcreateserial -extfile san.ext -out compta.crt 2>/dev/null
chmod 600 compta.key
cat >> /etc/nginx/sites-available/compta-tls <<'CONF'
server {
    listen 443 ssl;
    server_name compta.interne;
    ssl_certificate     /etc/ssl/compta/compta.crt;
    ssl_certificate_key /etc/ssl/compta/compta.key;
    root /var/www/compta-tls;
    index index.html;
}
CONF
systemctl reload nginx
sleep 1
