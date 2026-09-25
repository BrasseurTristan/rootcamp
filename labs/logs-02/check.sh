#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"

conf=/etc/logrotate.d/facturation-app
dir=/var/log/facturation-app
[[ -f $conf ]] || rc_die "$conf a disparu ! Relance le lab avec 'rootcamp reset'."
systemctl is-active --quiet facturation-journal || systemctl start facturation-journal

state=$(mktemp)
if logrotate -d -s "$state" "$conf" 2>&1 | grep -qiE '^error|: error'; then
  ko "la configuration logrotate est valide (logrotate -d)"
else
  ok "la configuration logrotate est valide (logrotate -d)"
fi
expect_ok "les logs sont archivés chaque jour (daily)" grep -qE '^[[:space:]]*daily' "$conf"
expect_ok "on garde 7 archives (rotate 7)" grep -qE '^[[:space:]]*rotate[[:space:]]+7[[:space:]]*$' "$conf"
expect_ok "les archives sont compressées (compress)" grep -qE '^[[:space:]]*compress' "$conf"

# Une vraie rotation, comme celle de la nuit.
logrotate -f -s "$state" "$conf" &>/dev/null || true
rm -f "$state"
if ls "$dir"/app.log.1* &>/dev/null; then
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
used=$(du -sm "$dir" | cut -f1)
if (( used < 20 )); then
  ok "les logs n'occupent plus que $used Mo"
else
  ko "les logs n'occupent plus que peu de place ($used Mo)"
fi

rc_result
