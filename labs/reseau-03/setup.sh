#!/usr/bin/env bash
# Casse : le serveur relie le réseau des postes (10.10.0.0/24) à celui des
# serveurs (10.20.0.0/24), mais le routage est désactivé, et le serveur de base
# de données ne sait pas par où renvoyer ses réponses.
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"
# shellcheck source=../../lib/reseau.sh
source "$RC_LIB/reseau.sh"

reseau_parefeu_ouvert

reseau_machine poste-alice 10.10.0.1 10.10.0.2
reseau_machine srv-bdd 10.20.0.1 10.20.0.2 non
reseau_service rc-bdd ip netns exec srv-bdd nc -lk 5432

# Aucun routage, ni maintenant ni au prochain démarrage.
for f in /etc/sysctl.conf /etc/sysctl.d/*.conf /run/sysctl.d/*.conf /usr/local/lib/sysctl.d/*.conf; do
  if [[ -f $f ]]; then sed -i -E '/net[./]ipv4[./](ip_forward|conf[./]all[./]forwarding)/d' "$f"; fi
done
sysctl -q -w net.ipv4.ip_forward=0
