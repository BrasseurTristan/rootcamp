#!/usr/bin/env bash
# Casse : le pare-feu bloque l'intranet (8080), mais laisse la base de données
# (3306) ouverte à tout le réseau.
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"
# shellcheck source=../../lib/reseau.sh
source "$RC_LIB/reseau.sh"

reseau_machine poste-alice 10.10.0.1 10.10.0.2
for p in 8080 3306 9090; do reseau_liberer_port "$p"; done

mkdir -p /srv/intranet
echo "<h1>Intranet de la compta</h1>" > /srv/intranet/index.html
reseau_service rc-intranet python3 -m http.server --bind 0.0.0.0 --directory /srv/intranet 8080
reseau_service rc-mysql nc -lk 3306
reseau_service rc-debug nc -lk 9090

cat > /etc/nftables.conf <<'NFT'
#!/usr/sbin/nft -f
# Pare-feu du serveur — tout ce qui n'est pas autorisé explicitement est bloqué.

flush ruleset

table inet filtre {
  chain entree {
    type filter hook input priority filter; policy drop;

    iif lo accept
    ct state established,related accept
    meta l4proto { icmp, ipv6-icmp } accept

    tcp dport 22 accept        # SSH (administration)
    tcp dport 3306 accept      # base de données
  }
}
NFT
systemctl enable nftables &>/dev/null
systemctl reset-failed nftables &>/dev/null || true   # oublie les redémarrages trop rapprochés
systemctl restart nftables
for p in 8080 3306 9090; do rc_retry 10 reseau_ecoute "$p"; done
