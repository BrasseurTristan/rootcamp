#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"

cronfile=/etc/cron.d/sauvegarde-compta
log=/var/log/sauvegarde-compta.log
[[ -f $cronfile ]] || rc_die "$cronfile a disparu ! Relance le lab avec 'rootcamp reset'."

# cron_var <nom> : valeur donnée à une variable dans le fichier cron (la
# dernière), sans les guillemets qui l'entourent, comme le fait cron.
cron_var() {
  local v
  v=$(sed -n "s/^[[:space:]]*$1[[:space:]]*=[[:space:]]*//p" "$cronfile" | tail -n1)
  v=${v%"${v##*[![:space:]]}"}
  if [[ $v =~ ^\"(.*)\"$ || $v =~ ^\'(.*)\'$ ]]; then v=${BASH_REMATCH[1]}; fi
  echo "$v"
}
# Comme cron : PATH minimal et /bin/sh, sauf si le fichier définit PATH ou SHELL.
path=$(cron_var PATH)
path=${path:-/usr/bin:/bin}
shell=$(cron_var SHELL)
shell=${shell:-/bin/sh}
job=$(grep -vE '^[[:space:]]*(#|$|[A-Za-z_]+[[:space:]]*=)' "$cronfile" | head -n1)
read -r m h dom mon dow user cmd <<<"$job"

if [[ "$m $h $dom $mon $dow" == "30 2 * * *" ]]; then
  ok "la sauvegarde est toujours planifiée à 2 h 30"
else
  ko "la sauvegarde est toujours planifiée à 2 h 30 (planification actuelle : $m $h $dom $mon $dow)"
fi
if [[ $user == root ]]; then
  ok "la tâche tourne toujours en root"
else
  ko "la tâche tourne toujours en root (6e champ du fichier)"
fi

# On lance la tâche deux fois, exactement comme cron le ferait.
rm -f "$log"
run_like_cron() { env -i PATH="$path" HOME=/root SHELL="$shell" LOGNAME=root "$shell" -c "$cmd" >/dev/null 2>&1; }
if run_like_cron && run_like_cron; then
  ok "la tâche fonctionne dans l'environnement minimal de cron"
else
  ko "la tâche fonctionne dans l'environnement minimal de cron"
fi

count() { grep -c "$1" "$log" 2>/dev/null || true; }
if (( $(count terminée) >= 1 )); then
  ok "la sortie normale du script est enregistrée dans $log"
else
  ko "la sortie normale du script est enregistrée dans $log"
fi
if (( $(count avertissement) >= 1 )); then
  ok "les messages d'erreur du script sont enregistrés dans $log"
else
  ko "les messages d'erreur du script sont enregistrés dans $log"
fi
if (( $(count terminée) == 2 )); then
  ok "chaque exécution s'ajoute au log sans effacer les précédentes"
else
  ko "chaque exécution s'ajoute au log sans effacer les précédentes"
fi
rm -f "$log"

rc_result
