#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"

ip netns list | grep -qw poste-alice || rc_die "Le poste d'Alice a disparu ! Relance le lab avec 'rootcamp reset'."

expect_ok "le service intranet est démarré" systemctl is-active --quiet intranet
expect_ok "le service intranet démarrera au prochain redémarrage" systemctl is-enabled --quiet intranet
expect_ok "l'intranet répond depuis le poste d'Alice (http://10.10.0.1:8080)" \
  rc_retry 5 sh -c 'ip netns exec poste-alice curl -fsS --max-time 3 http://10.10.0.1:8080/ | grep -q Intranet'

rc_result
