#!/usr/bin/env bash
# Casse : le service « rapports », fourni par un paquet, a été tué cette nuit
# et n'a pas redémarré : son unité ne demande aucun redémarrage automatique.
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"

unit=/usr/lib/systemd/system/rapports.service
systemctl disable --now rapports &>/dev/null || true
rm -rf /etc/systemd/system/rapports.service /etc/systemd/system/rapports.service.d

rc_user rapports

cat > /usr/local/bin/generateur-rapports <<'SCRIPT'
#!/bin/sh
# Générateur de rapports (simulé).
echo "generateur-rapports : prêt"
while true; do sleep 60; done
SCRIPT
chmod 755 /usr/local/bin/generateur-rapports

cat > "$unit" <<'UNIT'
# Fourni par le paquet « rapports-pro » : ne pas modifier, ce fichier est
# remplacé à chaque mise à jour du paquet.
[Unit]
Description=Générateur de rapports de l'éditeur Rapports Pro

[Service]
User=rapports
ExecStart=/usr/local/bin/generateur-rapports

[Install]
WantedBy=multi-user.target
UNIT
sha256sum "$unit" > /var/lib/rootcamp/systemd-02.sha256

systemctl daemon-reload
systemctl enable --now rapports &>/dev/null
sleep 1
# La « nuit dernière » : le noyau tue le processus (comme le ferait l'OOM killer).
systemctl kill --signal=KILL rapports
rc_retry 5 sh -c '! systemctl is-active --quiet rapports'
