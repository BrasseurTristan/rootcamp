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
candidate=$(LC_ALL=C apt-cache policy facturation-agent | awk '/Candidate:/ {print $2}')
if [[ $candidate == 2.2 ]]; then
  ok "apt proposera les prochaines mises à jour de facturation-agent (aucun épinglage ne le retient)"
else
  ko "apt proposera les prochaines mises à jour de facturation-agent (candidat actuel : ${candidate:-aucun})"
fi

rc_result
