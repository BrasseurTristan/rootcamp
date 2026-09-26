#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"
# shellcheck source=../../lib/disques.sh
source "$RC_LIB/disques.sh"

lv=vg_donnees/postgres
lvs "$lv" &>/dev/null || rc_die "Le volume $lv a disparu ! Relance le lab avec 'rootcamp reset'."

expect_ok "/srv/bdd est monté" mountpoint -q /srv/bdd
expect_ok "les données de la base sont intactes" \
  sh -c 'cd /srv/bdd && sha256sum --status -c /var/lib/rootcamp/stockage-03.sha256 && [ -f base/factures.db ]'

lv_mb=$(lvs --noheadings --units m --nosuffix -o lv_size "$lv" | awk '{printf "%d", $1}')
if (( lv_mb >= 800 )); then
  ok "le volume logique fait au moins 800 Mo (${lv_mb} Mo)"
else
  ko "le volume logique fait au moins 800 Mo (${lv_mb} Mo)"
fi
fs_mb=$(df -BM --output=size /srv/bdd 2>/dev/null | tail -n1 | tr -dc '0-9')
if (( ${fs_mb:-0} >= 750 )); then
  ok "le système de fichiers a été agrandi lui aussi (${fs_mb} Mo)"
else
  ko "le système de fichiers a été agrandi lui aussi (${fs_mb:-0} Mo)"
fi
d2=$(disque_dev bdd2)
if [[ -n $d2 ]] && [[ $(pvs --noheadings -o vg_name "$d2" 2>/dev/null | tr -d ' ') == vg_donnees ]]; then
  ok "le second disque fait partie du groupe de volumes vg_donnees"
else
  ko "le second disque fait partie du groupe de volumes vg_donnees"
fi

rc_result
