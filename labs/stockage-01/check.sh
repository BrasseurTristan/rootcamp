#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"

d=/srv/donnees
mountpoint -q "$d" || rc_die "$d n'est plus monté ! Relance le lab avec 'rootcamp reset'."

expect_ok "les bilans et l'export de septembre sont intacts" \
  sh -c "cd $d && sha256sum --status -c /var/lib/rootcamp/stockage-01.sha256"

open_deleted=no
for fd in /proc/[0-9]*/fd/*; do
  target=$(readlink "$fd" 2>/dev/null) || continue
  if [[ $target == "$d/"*"(deleted)" ]]; then open_deleted=yes; break; fi
done
if [[ $open_deleted == no ]]; then
  ok "aucun processus ne garde ouvert un fichier supprimé sur $d"
else
  ko "aucun processus ne garde ouvert un fichier supprimé sur $d"
fi

usage=$(df --output=pcent "$d" | tail -n1 | tr -dc '0-9')
if (( usage <= 20 )); then
  ok "au moins 80 % de l'espace de $d est libre (utilisé : $usage %)"
else
  ko "au moins 80 % de l'espace de $d est libre (utilisé : $usage %)"
fi

rc_result
