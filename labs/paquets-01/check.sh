#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"
# shellcheck source=../../lib/depot.sh
source "$RC_LIB/depot.sh"

[[ -f $DEPOT/InRelease ]] || rc_die "Le dépôt $DEPOT a disparu ! Relance le lab avec 'rootcamp reset'."

if grep -rqiE 'trusted' /etc/apt/sources.list /etc/apt/sources.list.d/ 2>/dev/null; then
  ko "aucune source APT ne désactive la vérification des signatures (trusted)"
else
  ok "aucune source APT ne désactive la vérification des signatures (trusted)"
fi

out=$(LC_ALL=C apt-get update 2>&1 || true)
depot_lines=$(grep -E 'depot[-_]interne' <<<"$out" || true)
if grep -qE '^(Get|Hit):' <<<"$depot_lines"; then
  ok "apt lit le dépôt interne"
else
  ko "apt lit le dépôt interne"
fi
if grep -qE '^(Err|W:|E:)' <<<"$depot_lines"; then
  ko "apt ne signale aucune erreur ni avertissement sur le dépôt interne (lance 'sudo apt update')"
else
  ok "apt ne signale aucune erreur ni avertissement sur le dépôt interne"
fi

if [[ -n $(depot_version_installee) ]]; then
  ok "le paquet facturation-agent est installé"
else
  ko "le paquet facturation-agent est installé"
fi
expect_ok "la commande facturation-agent fonctionne" facturation-agent

rc_result
