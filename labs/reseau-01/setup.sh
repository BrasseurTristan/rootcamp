#!/usr/bin/env bash
# Casse : l'intranet n'écoute que sur 127.0.0.1 : il répond sur le serveur
# lui-même, mais pas depuis le poste d'Alice.
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"
# shellcheck source=../../lib/reseau.sh
source "$RC_LIB/reseau.sh"

reseau_parefeu_ouvert

systemctl disable --now intranet &>/dev/null || true
reseau_liberer_port 8080
reseau_machine poste-alice 10.10.0.1 10.10.0.2

mkdir -p /srv/intranet
cat > /srv/intranet/index.html <<'HTML'
<h1>Intranet de la compta</h1>
<p>Bienvenue ! Les bilans sont dans l'onglet Documents.</p>
HTML
cat > /etc/intranet.conf <<'CONF'
# Configuration de l'intranet
# ADRESSE : adresse IP sur laquelle l'intranet attend les connexions
ADRESSE=127.0.0.1
PORT=8080
CONF
cat > /etc/systemd/system/intranet.service <<'UNIT'
[Unit]
Description=Intranet de la compta
After=network.target

[Service]
EnvironmentFile=/etc/intranet.conf
ExecStart=/usr/bin/python3 -m http.server --bind ${ADRESSE} --directory /srv/intranet ${PORT}
DynamicUser=yes

[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload
systemctl enable --now intranet &>/dev/null
rc_retry 10 reseau_ecoute 8080
