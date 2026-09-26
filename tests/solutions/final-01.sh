#!/usr/bin/env bash
# Solution de référence du projet final.
set -euo pipefail

# Le compte et les données
useradd --system --home-dir /var/lib/carnet --shell /usr/sbin/nologin carnet
install -d -o carnet -g carnet -m 750 /var/lib/carnet

# Le service
cat > /etc/systemd/system/carnet.service <<'UNIT'
[Unit]
Description=Carnet de notes
After=network.target

[Service]
User=carnet
ExecStart=/opt/carnet/carnet.py
Restart=on-failure

[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload
systemctl enable --now carnet

# Le certificat
mkdir -p /etc/ssl/carnet
cd /etc/ssl/carnet
openssl req -new -newkey rsa:2048 -nodes -subj "/CN=carnet.interne" -keyout carnet.key -out carnet.csr 2>/dev/null
echo "subjectAltName=DNS:carnet.interne" > san.ext
openssl x509 -req -in carnet.csr -days 365 -CA /srv/pki/ca.crt -CAkey /srv/pki/ca.key \
  -CAcreateserial -extfile san.ext -out carnet.crt 2>/dev/null
chmod 600 carnet.key

# nginx
cat > /etc/nginx/sites-available/carnet <<'CONF'
server {
    listen 443 ssl;
    server_name carnet.interne;
    ssl_certificate     /etc/ssl/carnet/carnet.crt;
    ssl_certificate_key /etc/ssl/carnet/carnet.key;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}

server {
    listen 80 default_server;
    server_name carnet.interne;
    return 301 https://$host$request_uri;
}
CONF
ln -sf /etc/nginx/sites-available/carnet /etc/nginx/sites-enabled/carnet
nginx -t -q
systemctl reload nginx

# Le pare-feu
cat > /etc/nftables.conf <<'NFT'
#!/usr/sbin/nft -f
flush ruleset

table inet filter {
  chain input {
    type filter hook input priority filter; policy drop;
    iif lo accept
    ct state established,related accept
    meta l4proto { icmp, ipv6-icmp } accept
    tcp dport { 22, 80, 443 } accept
  }
}
NFT
nft -c -f /etc/nftables.conf
systemctl enable nftables
systemctl restart nftables
sleep 1
