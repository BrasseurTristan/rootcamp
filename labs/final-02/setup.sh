#!/usr/bin/env bash
# Prépare : le carnet est déployé correctement… puis trois pannes sont tirées
# au sort parmi six. Chaque « rootcamp reset » donne une nouvelle nuit.
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"
# shellcheck source=../../lib/reseau.sh
source "$RC_LIB/reseau.sh"
# shellcheck source=../../lib/web.sh
source "$RC_LIB/web.sh"
# shellcheck source=../../lib/carnet.sh
source "$RC_LIB/carnet.sh"

carnet_nettoyer
carnet_ca
carnet_appli
carnet_environnement
carnet_deployer

mapfile -t pannes < <(shuf -n 3 -e donnees service proxy certificat pare-feu dns)
printf '%s\n' "${pannes[@]}" > /var/lib/rootcamp/final-02.pannes
chmod 600 /var/lib/rootcamp/final-02.pannes

for panne in "${pannes[@]}"; do
  case $panne in
    donnees)      # une « restauration de sauvegarde » faite en root
      chown -R root:root /var/lib/carnet
      chmod 700 /var/lib/carnet ;;
    service)      # une mise à jour qui a déplacé le programme
      sed -i 's|^ExecStart=.*|ExecStart=/opt/carnet/carnet-v2.py|' /etc/systemd/system/carnet.service
      systemctl daemon-reload
      systemctl restart carnet &>/dev/null || true ;;
    proxy)        # un « nettoyage » de la configuration nginx
      sed -i 's|proxy_pass http://127.0.0.1:5000;|proxy_pass http://127.0.0.1:5050;|' /etc/nginx/sites-available/carnet ;;
    certificat)   # un renouvellement de certificat raté
      openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out /etc/ssl/carnet/carnet-2026.key 2>/dev/null
      chmod 600 /etc/ssl/carnet/carnet-2026.key
      sed -i 's|ssl_certificate_key .*|ssl_certificate_key /etc/ssl/carnet/carnet-2026.key;|' /etc/nginx/sites-available/carnet ;;
    pare-feu)     # une règle supprimée par erreur
      sed -i 's/tcp dport { 22, 80, 443 } accept/tcp dport { 22, 80 } accept/' /etc/nftables.conf
      systemctl restart nftables ;;
    dns)          # une vieille entrée de /etc/hosts « restaurée »
      web_hosts carnet.interne 10.99.0.14 ;;
  esac
done
# Comme après un redémarrage : les services relisent leur configuration.
systemctl restart nginx &>/dev/null || true
