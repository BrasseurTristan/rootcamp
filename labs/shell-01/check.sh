#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"

conf=/etc/facturation/facturation.conf
good=/srv/sauvegardes/2025-06/etc/facturation/facturation.conf
[[ -f $good ]] || rc_die "Les sauvegardes ont disparu ! Relance le lab avec 'rootcamp reset'."

if [[ -f $conf ]]; then
  ok "$conf existe"
else
  ko "$conf existe"
fi
if [[ -f $conf ]] && cmp -s "$conf" "$good"; then
  ok "c'est la bonne version de la configuration (celle de production la plus récente)"
else
  ko "c'est la bonne version de la configuration (celle de production la plus récente)"
fi
if [[ -f $conf && $(stat -c %U "$conf") == root ]]; then
  ok "la configuration appartient à root"
else
  ko "la configuration appartient à root"
fi
expect_ok "l'application démarre (commande 'facturation')" /usr/local/bin/facturation

rc_result
