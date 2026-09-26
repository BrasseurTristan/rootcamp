#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"

ip netns list | grep -qw poste-alice || rc_die "Le poste d'Alice a disparu ! Relance le lab avec 'rootcamp reset'."

# shellcheck source=../../lib/reseau.sh
source "$RC_LIB/reseau.sh"

valide=0
if nft -c -f /etc/nftables.conf &>/dev/null; then
  ok "la configuration du pare-feu (/etc/nftables.conf) est valide"; valide=1
else
  ko "la configuration du pare-feu (/etc/nftables.conf) est valide"
fi
expect_ok "le pare-feu est chargé au démarrage (service nftables activé)" systemctl is-enabled --quiet nftables

# Avant d'appliquer la configuration, on vérifie sur une machine jetable
# qu'elle laisse passer SSH : sinon on couperait ta connexion à la VM.
if (( valide )) && reseau_parefeu_laisse_ssh /etc/nftables.conf; then
  ok "SSH (port 22) reste autorisé depuis n'importe quelle adresse (sinon tu te couperais l'accès !)"
  # On recharge le pare-feu depuis sa configuration, comme au démarrage.
  systemctl reset-failed nftables &>/dev/null || true
  systemctl restart nftables &>/dev/null || true
else
  ko "SSH (port 22) reste autorisé depuis n'importe quelle adresse (sinon tu te couperais l'accès !)"
  if (( valide )); then echo "    (configuration non appliquée : elle t'aurait coupé l'accès à la VM)"; fi
fi

alice() { ip netns exec poste-alice "$@"; }
expect_ok "depuis le poste d'Alice, l'intranet répond (port 8080)" \
  alice curl -fsS --max-time 3 -o /dev/null http://10.10.0.1:8080/
expect_fail "depuis le poste d'Alice, la base de données est inaccessible (port 3306)" \
  alice nc -z -w 2 10.10.0.1 3306
expect_fail "depuis le poste d'Alice, les autres ports restent fermés (ex. 9090)" \
  alice nc -z -w 2 10.10.0.1 9090
expect_ok "la base de données reste utilisable depuis le serveur lui-même" nc -z -w 2 127.0.0.1 3306

rc_result
