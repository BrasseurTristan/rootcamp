#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"

log=/var/log/facturation/acces.log
report="$(rc_home)/rapport-erreurs.txt"
[[ -f $log ]] || rc_die "$log a disparu ! Relance le lab avec 'rootcamp reset'."

if [[ ! -f $report ]]; then
  ko "le fichier $report existe"
  rc_result
fi
ok "le fichier $report existe"

mapfile -t expected < <(awk '$9 == 500 {print $1}' "$log" | sort | uniq -c | sort -rn | head -3 | awk '{print $2}')
# On accepte « 1.2.3.4 » comme « 57 1.2.3.4 » : on ne garde que l'adresse IP de chaque ligne.
mapfile -t given < <(grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' "$report")

if (( ${#given[@]} == 3 )); then
  ok "le rapport contient 3 adresses IP"
else
  ko "le rapport contient 3 adresses IP (il en contient ${#given[@]})"
fi
if [[ "${given[*]}" == "${expected[*]}" ]]; then
  ok "ce sont les 3 IP qui ont provoqué le plus d'erreurs 500, dans le bon ordre"
else
  ko "ce sont les 3 IP qui ont provoqué le plus d'erreurs 500, dans le bon ordre"
fi

rc_result
