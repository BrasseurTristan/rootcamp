# shellcheck shell=bash
# Des « machines » simulées avec des espaces de noms réseau (netns) : chacune a
# sa propre carte réseau (eth0), reliée au serveur par un câble virtuel (veth).
# Pour lancer une commande « sur » une machine : ip netns exec <machine> <commande>

# reseau_machine <nom> <ip du serveur> <ip de la machine> [route]
# Crée la machine <nom> et un réseau /24 entre elle et le serveur. Avec
# route=oui (par défaut), la machine passe par le serveur pour sortir de son réseau.
reseau_machine() {
  local nom=$1 ip_srv=$2 ip_m=$3 route=${4:-oui} veth
  veth=$(_reseau_veth "$nom")
  reseau_supprimer "$nom"
  ip netns add "$nom"
  ip link add "$veth" type veth peer name eth0 netns "$nom"
  ip addr add "$ip_srv/24" dev "$veth"
  ip link set "$veth" up
  ip -n "$nom" link set lo up
  ip -n "$nom" addr add "$ip_m/24" dev eth0
  ip -n "$nom" link set eth0 up
  if [[ $route == oui ]]; then ip -n "$nom" route add default via "$ip_srv"; fi
}

# reseau_supprimer <nom> : supprime la machine et son câble.
reseau_supprimer() {
  ip netns pids "$1" 2>/dev/null | xargs -r kill -KILL 2>/dev/null || true
  ip netns del "$1" 2>/dev/null || true
  ip link del "$(_reseau_veth "$1")" 2>/dev/null || true
}

# reseau_service <unité> <commande…> : lance un petit service réseau (unité systemd
# temporaire), après avoir arrêté une éventuelle version précédente.
reseau_service() {
  local unit=$1; shift
  systemctl stop "$unit" &>/dev/null || true
  systemctl reset-failed "$unit" &>/dev/null || true
  systemd-run --quiet --unit="$unit" "$@"
}

# reseau_ecoute <port> : vrai quand un programme écoute sur ce port TCP.
reseau_ecoute() { ss -Htln "sport = :$1" | grep -q .; }

# reseau_parefeu_ouvert : si le pare-feu du lab reseau-04 est en place, remet la
# configuration par défaut de Debian (tout est autorisé), pour qu'il ne gêne pas
# les autres labs.
reseau_parefeu_ouvert() {
  command -v nft >/dev/null || return 0
  grep -qs 'table inet filtre' /etc/nftables.conf || nft list tables 2>/dev/null | grep -qw filtre || return 0
  cat > /etc/nftables.conf <<'NFT'
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
	chain input {
		type filter hook input priority filter;
	}
	chain forward {
		type filter hook forward priority filter;
	}
	chain output {
		type filter hook output priority filter;
	}
}
NFT
  nft -f /etc/nftables.conf
}

_reseau_veth() { echo "rc-${1:0:12}"; }
