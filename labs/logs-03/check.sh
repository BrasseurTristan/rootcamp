#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"

# La configuration effective : pour journald, c'est la DERNIÈRE valeur lue qui gagne.
effective() { systemd-analyze cat-config systemd/journald.conf 2>/dev/null | sed -n "s/^[[:space:]]*$1[[:space:]]*=[[:space:]]*//p" | tail -n1; }
storage=$(effective Storage)
if [[ $storage == persistent ]] || { [[ ${storage:-auto} == auto ]] && [[ -d /var/log/journal ]]; }; then
  ok "le journal est configuré pour être conservé sur le disque"
else
  ko "le journal est configuré pour être conservé sur le disque (Storage=${storage:-auto})"
fi
max=$(effective SystemMaxUse)
if [[ $max =~ ^([0-9]+)([KMG]?)$ ]] && {
     [[ ${BASH_REMATCH[2]} == G && ${BASH_REMATCH[1]} -le 1 ]] ||
     [[ ${BASH_REMATCH[2]} == M && ${BASH_REMATCH[1]} -le 1024 ]] ||
     [[ ${BASH_REMATCH[2]} =~ ^K?$ ]]; }; then
  ok "sa taille sur le disque est limitée (SystemMaxUse=$max)"
else
  ko "sa taille sur le disque est limitée à 1 Go maximum (SystemMaxUse=${max:-non défini})"
fi

# journald a-t-il été redémarré, et écrit-il vraiment sur le disque ?
logger -t rootcamp "vérification du journal persistant" 2>/dev/null || true
journalctl --flush &>/dev/null || true
if find /var/log/journal -name 'system*.journal' 2>/dev/null | grep -q .; then
  ok "le journal est bien écrit dans /var/log/journal"
else
  ko "le journal est bien écrit dans /var/log/journal"
fi

rc_result
