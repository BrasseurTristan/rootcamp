#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"
# shellcheck source=../../lib/carnet.sh
source "$RC_LIB/carnet.sh"

[[ -f /opt/carnet/carnet.py && -f $CARNET_CA ]] || rc_die "Des fichiers du lab ont disparu ! Relance-le avec 'rootcamp reset'."

echo "  -- Le compte et le service"
if id carnet &>/dev/null && (( $(id -u carnet) < 1000 )) \
   && [[ $(getent passwd carnet | cut -d: -f7) =~ (nologin|false)$ ]]; then
  ok "carnet est un compte système, sans shell de connexion"
else
  ko "carnet est un compte système, sans shell de connexion"
fi
restart=$(systemctl show -p Restart --value carnet 2>/dev/null || true)
if [[ $restart == on-failure || $restart == always ]]; then
  ok "systemd relance le service s'il plante"
else
  ko "systemd relance le service s'il plante"
fi
if [[ -f /etc/ssl/carnet/carnet.key && $(stat -c %U /etc/ssl/carnet/carnet.key) == root ]] \
   && (( (8#$(stat -c %a /etc/ssl/carnet/carnet.key) & 077) == 0 )); then
  ok "la clé privée /etc/ssl/carnet/carnet.key n'est lisible que par root"
else
  ko "la clé privée /etc/ssl/carnet/carnet.key existe et n'est lisible que par root"
fi

echo "  -- De bout en bout"
carnet_verifier

rc_result
