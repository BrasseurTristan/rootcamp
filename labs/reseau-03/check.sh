#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"

for m in poste-alice srv-bdd; do
  ip netns list | grep -qw "$m" || rc_die "La machine $m a disparu ! Relance le lab avec 'rootcamp reset'."
done

if [[ $(sysctl -n net.ipv4.ip_forward) == 1 ]]; then
  ok "le serveur route les paquets entre ses réseaux"
else
  ko "le serveur route les paquets entre ses réseaux"
fi
if grep -hsE '^[[:space:]]*net\.ipv4\.ip_forward[[:space:]]*=[[:space:]]*1' /etc/sysctl.conf /etc/sysctl.d/*.conf | grep -q .; then
  ok "le routage restera actif après un redémarrage"
else
  ko "le routage restera actif après un redémarrage"
fi
expect_ok "le poste d'Alice joint la base de données (10.20.0.2, port 5432)" \
  rc_retry 3 ip netns exec poste-alice nc -z -w 2 10.20.0.2 5432

rc_result
