#!/usr/bin/env bash
# Casse : nginx sert un site rangé dans le dossier personnel d'alice (que nginx
# ne peut pas traverser), et la page d'accueil ne porte pas le nom attendu.
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"
# shellcheck source=../../lib/web.sh
source "$RC_LIB/web.sh"

rc_user alice
chmod 750 /home/alice
rm -rf /var/www/compta
mkdir -p /home/alice/site-compta
cat > /home/alice/site-compta/accueil.html <<'HTML'
<!doctype html>
<meta charset="utf-8">
<title>Espace Compta</title>
<h1>Espace Compta</h1>
<p>Les bilans et les factures de l'entreprise.</p>
HTML
chown -R alice:alice /home/alice/site-compta

cat > /etc/nginx/sites-available/compta <<'CONF'
# Site interne de la compta
server {
    listen 80 default_server;
    server_name _;

    root /home/alice/site-compta;
    index index.html;

    access_log /var/log/nginx/compta.access.log;
    error_log  /var/log/nginx/compta.error.log;
}
CONF
web_site compta
