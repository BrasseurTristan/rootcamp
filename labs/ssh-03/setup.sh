#!/usr/bin/env bash
# Prépare : l'interface d'administration de la base n'écoute que sur
# 127.0.0.1 de srv-bdd. Il faut y accéder par un tunnel SSH, et se faciliter
# la vie avec un alias dans ~/.ssh/config.
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"
# shellcheck source=../../lib/reseau.sh
source "$RC_LIB/reseau.sh"
# shellcheck source=../../lib/ssh.sh
source "$RC_LIB/ssh.sh"

# Arrête un éventuel tunnel d'une tentative précédente.
for pid in $(ss -Htlnp 'sport = :9000' | grep -o 'pid=[0-9]*' | cut -d= -f2 | sort -u); do
  kill "$pid" 2>/dev/null || true
done

ssh_serveur srv-bdd 10.20.0.1 10.20.0.2
rc_user deploy
key="$(rc_home)/.ssh/cle_bdd"
ssh_autoriser deploy "$(ssh_cle "$key")"
chmod 600 "$key"

# Retire un éventuel bloc « Host bdd » d'une tentative précédente.
conf="$(rc_home)/.ssh/config"
if [[ -f $conf ]]; then
  awk 'tolower($1) == "host" { skip = ($2 == "bdd") } !skip' "$conf" > "$conf.rootcamp"
  cat "$conf.rootcamp" > "$conf" && rm -f "$conf.rootcamp"
fi
rm -f "$(rc_home)/jeton.txt"

# L'interface d'administration, qui n'écoute que sur 127.0.0.1 de srv-bdd.
jeton=$(head -c 12 /dev/urandom | od -An -tx1 | tr -d ' \n')
echo "$jeton" > /var/lib/rootcamp/ssh-03.jeton
mkdir -p /srv/admin-bdd
cat > /srv/admin-bdd/index.html <<HTML
<h1>Administration de la base de données</h1>
<p>Jeton de session : $jeton</p>
HTML
reseau_service rc-admin-bdd ip netns exec srv-bdd \
  python3 -m http.server --bind 127.0.0.1 --directory /srv/admin-bdd 8080

ssh_demarrer srv-bdd
