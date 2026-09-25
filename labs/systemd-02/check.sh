#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"

svc=rapports
[[ -f /var/lib/rootcamp/systemd-02.sha256 ]] || rc_die "État du lab introuvable. Relance-le avec 'rootcamp reset'."

expect_ok "le fichier d'unité du paquet n'a pas été modifié" sha256sum --status -c /var/lib/rootcamp/systemd-02.sha256
if [[ -n $(systemctl show -p DropInPaths --value "$svc") ]]; then
  ok "la configuration est personnalisée avec un fichier de surcharge (drop-in)"
else
  ko "la configuration est personnalisée avec un fichier de surcharge (drop-in)"
fi
if [[ $(systemctl show -p NeedDaemonReload --value "$svc") == no ]]; then
  ok "systemd a relu la configuration"
else
  ko "systemd a relu la configuration"
fi
expect_ok "le service $svc est démarré" rc_retry 5 systemctl is-active --quiet "$svc"
expect_ok "le service $svc est activé au démarrage" systemctl is-enabled --quiet "$svc"

# Le test décisif : on tue le processus, comme cette nuit.
old=$(systemctl show -p MainPID --value "$svc")
restarted=no
if [[ $old != 0 ]]; then
  kill -KILL "$old" 2>/dev/null || true
  for _ in $(seq 20); do
    sleep 1
    new=$(systemctl show -p MainPID --value "$svc")
    if [[ $new != 0 && $new != "$old" ]] && systemctl is-active --quiet "$svc"; then
      restarted=yes
      break
    fi
  done
fi
if [[ $restarted == yes ]]; then
  ok "après un plantage (kill -9), systemd relance le service tout seul"
else
  ko "après un plantage (kill -9), systemd relance le service tout seul"
fi

rc_result
