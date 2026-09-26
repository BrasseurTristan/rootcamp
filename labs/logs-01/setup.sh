#!/usr/bin/env bash
# Casse : le service paiements plante en boucle à cause d'une valeur invalide
# dans sa configuration. Le message d'erreur est noyé au milieu de centaines de
# lignes d'information.
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"

systemctl stop paiements &>/dev/null || true
systemctl reset-failed paiements &>/dev/null || true

mkdir -p /etc/paiements
cat > /etc/paiements/paiements.conf <<'CONF'
# Configuration du service de paiements
banque=banque-populaire-api
delai_max=30
nombre_tentatives=3
journal_detaille=oui
devise=EURO
CONF

cat > /usr/local/bin/paiements <<'SCRIPT'
#!/bin/bash
# Service de paiements (simulé). Les lignes qui commencent par <3> sont des
# erreurs pour le journal (priorité « err »), les autres des informations.
conf=/etc/paiements/paiements.conf
devise=$(sed -n 's/^devise=//p' "$conf")
for i in $(seq 1 150); do echo "chargement du module de paiement $i/150"; done
case $devise in
  EUR|USD|CHF) ;;
  *)
    echo "<3>ERREUR : $conf : devise « $devise » inconnue (valeurs possibles : EUR, USD, CHF)"
    for i in $(seq 150 -1 1); do echo "arrêt du module de paiement $i/150"; done
    exit 3 ;;
esac
echo "service de paiements prêt (devise $devise)"
while true; do sleep 60; done
SCRIPT
chmod 755 /usr/local/bin/paiements

cat > /etc/systemd/system/paiements.service <<'UNIT'
[Unit]
Description=Service de paiements
StartLimitIntervalSec=0

[Service]
ExecStart=/usr/local/bin/paiements
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload
systemctl enable paiements &>/dev/null
systemctl start paiements
