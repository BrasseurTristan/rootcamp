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
sed -i '/net\.ipv4\.ip_forward/d' /etc/sysctl.conf 2>/dev/null || true
for f in /etc/sysctl.d/*.conf; do
  [[ -f $f ]] && sed -i '/net\.ipv4\.ip_forward/d' "$f"
done
sysctl -q -w net.ipv4.ip_forward=0
