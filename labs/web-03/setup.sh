#!/usr/bin/env bash
# Prépare : le site compta.interne n'est servi qu'en HTTP. L'autorité de
# certification (CA) interne de l'entreprise est disponible dans /srv/pki.
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"
# shellcheck source=../../lib/web.sh
source "$RC_LIB/web.sh"

rm -rf /etc/ssl/compta /srv/pki
mkdir -p /srv/pki
openssl req -x509 -newkey rsa:2048 -nodes -days 3650 -sha256 \
  -subj "/O=Entreprise/CN=CA interne de l'entreprise" \
  -keyout /srv/pki/ca.key -out /srv/pki/ca.crt 2>/dev/null
chmod 600 /srv/pki/ca.key

web_hosts compta.interne
mkdir -p /var/www/compta-tls
cat > /var/www/compta-tls/index.html <<'HTML'
<!doctype html>
<meta charset="utf-8">
<title>Compta</title>
<h1>Espace Compta sécurisé</h1>
HTML

cat > /etc/nginx/sites-available/compta-tls <<'CONF'
# Site interne de la compta : compta.interne
server {
    listen 80 default_server;
    server_name compta.interne;

    root /var/www/compta-tls;
    index index.html;
}
CONF
web_site compta-tls
