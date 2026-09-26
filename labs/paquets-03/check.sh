#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"
# shellcheck source=../../lib/depot.sh
source "$RC_LIB/depot.sh"

version=$(depot_version_installee)
if [[ $version == 2.2 ]]; then
  ok "facturation-agent est en version 2.2"
else
  ko "facturation-agent est en version 2.2 (version installée : ${version:-aucune})"
fi
if apt-mark showhold | grep -qx facturation-agent; then
  ko "facturation-agent n'est plus bloqué (hold)"
else
  ok "facturation-agent n'est plus bloqué (hold)"
fi
# Le vrai test : si la 2.3 sortait demain, apt la proposerait-il ?
futur=$(depot_candidat_futur)
if [[ $futur == 2.3 ]]; then
  ok "apt proposera les prochaines mises à jour de facturation-agent (aucun épinglage ne le retient)"
else
  ko "apt proposera les prochaines mises à jour de facturation-agent (si une 2.3 sortait, apt choisirait : ${futur:-rien})"
fi

rc_result
