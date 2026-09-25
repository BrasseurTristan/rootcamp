#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"

ip netns list | grep -qw poste-alice || rc_die "Le poste d'Alice a disparu ! Relance le lab avec 'rootcamp reset'."

expect_ok "la configuration du pare-feu (/etc/nftables.conf) est valide" nft -c -f /etc/nftables.conf
expect_ok "le pare-feu est chargé au démarrage (service nftables activé)" systemctl is-enabled --quiet nftables

# On recharge le pare-feu depuis sa configuration, comme au démarrage.
systemctl restart nftables &>/dev/null || true

alice() { ip netns exec poste-alice "$@"; }
expect_ok "depuis le poste d'Alice, l'intranet répond (port 8080)" \
  alice curl -fsS --max-time 3 -o /dev/null http://10.10.0.1:8080/
expect_fail "depuis le poste d'Alice, la base de données est inaccessible (port 3306)" \
  alice nc -z -w 2 10.10.0.1 3306
expect_fail "depuis le poste d'Alice, les autres ports restent fermés (ex. 9090)" \
  alice nc -z -w 2 10.10.0.1 9090
if nft list ruleset | grep -qE 'dport (22|ssh|\{[^}]*\b(22|ssh)\b[^}]*\}).*accept'; then
  ok "SSH est toujours autorisé (sinon tu te couperais l'accès !)"
else
  ko "SSH est toujours autorisé (sinon tu te couperais l'accès !)"
fi
expect_ok "la base de données reste utilisable depuis le serveur lui-même" nc -z -w 2 127.0.0.1 3306

rc_result
