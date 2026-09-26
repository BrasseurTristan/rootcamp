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
# Ce que systemd-sysctl appliquera au prochain démarrage : il lit
# /etc/sysctl.d, /run/sysctl.d, /usr/local/lib/sysctl.d et /usr/lib/sysctl.d
# (plus /etc/sysctl.conf, que Debian 13 ne lit plus). La dernière valeur gagne.
persistent=$(/usr/lib/systemd/systemd-sysctl --cat-config 2>/dev/null | awk -F= '
  /^[[:space:]]*[#;]/ || NF < 2 { next }
  { k = $1; gsub(/[[:space:]]/, "", k); sub(/^-/, "", k); gsub("/", ".", k)
    v = $2; gsub(/[[:space:]]/, "", v)
    if (k == "net.ipv4.ip_forward" || k == "net.ipv4.conf.all.forwarding") last = v }
  END { print last }')
if [[ $persistent == 1 ]]; then
  ok "le routage restera actif après un redémarrage"
else
  ko "le routage restera actif après un redémarrage (Debian 13 ne lit plus /etc/sysctl.conf : utilise /etc/sysctl.d/)"
fi
expect_ok "le poste d'Alice joint la base de données (10.20.0.2, port 5432)" \
  rc_retry 3 ip netns exec poste-alice nc -z -w 2 10.20.0.2 5432

rc_result
