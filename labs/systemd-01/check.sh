#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"

svc=facturation-api
id facturation &>/dev/null || rc_die "L'utilisateur facturation a disparu ! Relance le lab avec 'rootcamp reset'."

if [[ $(systemctl show -p NeedDaemonReload --value "$svc") == no ]]; then
  ok "systemd a relu la dernière version de l'unité"
else
  ko "systemd a relu la dernière version de l'unité (as-tu oublié une commande après avoir modifié le fichier ?)"
fi
expect_ok "le service $svc est démarré" rc_retry 5 systemctl is-active --quiet "$svc"
expect_ok "le service $svc démarrera automatiquement au prochain redémarrage" systemctl is-enabled --quiet "$svc"

pid=$(systemctl show -p MainPID --value "$svc")
if [[ $pid != 0 && $(stat -c %U "/proc/$pid" 2>/dev/null) == facturation ]]; then
  ok "le service tourne avec l'utilisateur facturation (pas en root)"
else
  ko "le service tourne avec l'utilisateur facturation (pas en root)"
fi

beat=/run/facturation/battement
if rc_retry 5 test -f "$beat" && (( $(date +%s) - $(stat -c %Y "$beat") <= 5 )); then
  ok "l'API fonctionne (son battement de cœur est à jour)"
else
  ko "l'API fonctionne (son battement de cœur est à jour)"
fi

rc_result
