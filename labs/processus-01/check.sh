#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"

id bob &>/dev/null || rc_die "L'utilisateur bob a disparu ! Relance le lab avec 'rootcamp reset'."

# On laisse au surveillant le temps de relancer l'indexeur, s'il tourne encore.
sleep 4
if [[ -z $(rc_pids /opt/outils/indexeur) ]]; then
  ok "l'indexeur ne tourne plus (et n'est pas revenu)"
else
  ko "l'indexeur ne tourne plus (et n'est pas revenu)"
fi
if [[ -z $(rc_pids /opt/outils/surveillant) ]]; then
  ok "le programme qui relançait l'indexeur est arrêté"
else
  ko "le programme qui relançait l'indexeur est arrêté"
fi
if grep -qs surveillant /var/spool/cron/crontabs/bob; then
  ko "rien ne relancera le problème au prochain redémarrage"
else
  ok "rien ne relancera le problème au prochain redémarrage"
fi
expect_ok "le compte de bob existe toujours (on ne supprime pas un collègue !)" id bob

rc_result
