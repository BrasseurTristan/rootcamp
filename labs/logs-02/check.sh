#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"

conf=/etc/logrotate.d/facturation-app
dir=/var/log/facturation-app
[[ -f $conf ]] || rc_die "$conf a disparu ! Relance le lab avec 'rootcamp reset'."
systemctl is-active --quiet facturation-journal || systemctl start facturation-journal

state="$(mktemp -d)/etat"   # un état neuf : la rotation forcée a toujours lieu
simulation=$(logrotate -d -s "$state" "$conf" 2>&1 || true)
if grep -qiE '^error|: error' <<<"$simulation"; then
  ko "la configuration logrotate est valide (logrotate -d)"
else
  ok "la configuration logrotate est valide (logrotate -d)"
fi
expect_ok "les logs sont archivés chaque jour (daily)" grep -qE '^[[:space:]]*daily' "$conf"
expect_ok "on garde 7 archives (rotate 7)" grep -qE '^[[:space:]]*rotate[[:space:]]+7[[:space:]]*$' "$conf"
expect_ok "les archives sont compressées (compress)" grep -qE '^[[:space:]]*compress' "$conf"

# Une vraie rotation, comme celle de la nuit. Les archives existantes sont
# d'abord effacées : avec « dateext », celle du jour empêcherait la rotation.
# Les archives peuvent s'appeler app.log.1, app.log.1.gz, app.log-20260926…
# et être rangées ailleurs avec « olddir ».
olddir=$(awk '$1 == "olddir" {print $2}' "$conf" | tail -n1)
if [[ -n $olddir && $olddir != /* ]]; then olddir="$dir/$olddir"; fi
archives() { find "$dir" ${olddir:+"$olddir"} -maxdepth 1 -name 'app.log?*' 2>/dev/null; }
archives | xargs -r rm -f
# Un log vide n'est pas archivé (notifempty) : on y écrit une ligne d'abord.
echo "$(date '+%F %T') rootcamp : test de rotation" >> "$dir/app.log"
logrotate -f -s "$state" "$conf" &>/dev/null || true
rm -rf "$(dirname "$state")"
if [[ -n $(archives) ]]; then
  ok "la rotation archive bien app.log"
else
  ko "la rotation archive bien app.log"
fi
before=$(stat -c %s "$dir/app.log" 2>/dev/null || echo 0)
sleep 3
after=$(stat -c %s "$dir/app.log" 2>/dev/null || echo 0)
if (( after > before && after < 10000000 )); then
  ok "après la rotation, l'application continue d'écrire dans un app.log tout neuf"
else
  ko "après la rotation, l'application continue d'écrire dans un app.log tout neuf"
fi

rc_result
