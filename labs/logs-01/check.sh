#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"

expect_ok "la devise de la configuration est valide" grep -qE '^devise=(EUR|USD|CHF)$' /etc/paiements/paiements.conf
expect_ok "le service paiements est démarré" rc_retry 8 systemctl is-active --quiet paiements
sleep 3
pid=$(systemctl show -p MainPID --value paiements)
if systemctl is-active --quiet paiements && [[ -n $(journalctl -u paiements _PID="$pid" -g 'prêt' -q 2>/dev/null) ]]; then
  ok "le service reste en marche (il ne plante plus en boucle)"
else
  ko "le service reste en marche (il ne plante plus en boucle)"
fi

rc_result
