#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"
# shellcheck source=../../lib/reseau.sh
source "$RC_LIB/reseau.sh"
# shellcheck source=../../lib/carnet.sh
source "$RC_LIB/carnet.sh"

[[ -f /opt/carnet/carnet.py && -f $CARNET_CA ]] || rc_die "Des fichiers du lab ont disparu ! Relance-le avec 'rootcamp reset'."

carnet_verifier
if [[ $(getent hosts carnet.interne | awk '{print $1}') == 127.0.0.1 ]]; then
  ok "carnet.interne désigne bien ce serveur"
else
  ko "carnet.interne désigne bien ce serveur"
fi

if (( RC_FAILED == 0 )) && [[ -f /var/lib/rootcamp/final-02.pannes ]]; then
  echo
  echo "  Les pannes de cette nuit étaient : $(paste -sd, /var/lib/rootcamp/final-02.pannes | sed 's/,/, /g')"
fi
rc_result
