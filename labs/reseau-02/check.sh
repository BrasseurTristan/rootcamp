#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"

ip netns list | grep -qw srv-bdd || rc_die "Le serveur de base de données a disparu ! Relance le lab avec 'rootcamp reset'."

if [[ $(getent hosts db.interne | awk '{print $1}') == 10.20.0.2 ]]; then
  ok "le nom db.interne désigne le nouveau serveur (10.20.0.2)"
else
  ko "le nom db.interne désigne le nouveau serveur (10.20.0.2)"
fi
expect_ok "l'application joint sa base de données (commande test-bdd)" test-bdd
expect_ok "la configuration de l'application utilise toujours le nom db.interne" \
  grep -q '^hote=db.interne$' /etc/facturation/bdd.conf
expect_ok "localhost fonctionne toujours (tu n'as pas cassé /etc/hosts)" \
  sh -c 'getent hosts localhost | grep -qE "^(127\.0\.0\.1|::1) "'

rc_result
