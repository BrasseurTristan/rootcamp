#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"
# shellcheck source=../../lib/ssh.sh
source "$RC_LIB/ssh.sh"

ssh_verifier_machine srv-bdd

jeton=$(cat /var/lib/rootcamp/ssh-03.jeton 2>/dev/null) || rc_die "État du lab introuvable. Relance-le avec 'rootcamp reset'."

# 1. L'alias
cfg=$(runuser -u "$RC_USER" -- ssh -G bdd 2>/dev/null || true)
if grep -qx 'hostname 10.20.0.2' <<<"$cfg" && grep -qx 'user deploy' <<<"$cfg"; then
  ok "l'alias « bdd » de ~/.ssh/config désigne deploy@10.20.0.2"
else
  ko "l'alias « bdd » de ~/.ssh/config désigne deploy@10.20.0.2"
fi
expect_ok "« ssh bdd » te connecte directement, avec la bonne clé" ssh_test "$RC_USER" bdd

# 2. Le tunnel
if ss -Htlnp 'sport = :9000' | grep -q '"ssh"'; then
  ok "un tunnel SSH écoute sur le port 9000 du serveur"
else
  ko "un tunnel SSH écoute sur le port 9000 du serveur"
fi
expect_ok "http://127.0.0.1:9000 affiche l'interface d'administration de srv-bdd" \
  sh -c "curl -fsS --max-time 3 http://127.0.0.1:9000/ | grep -q '$jeton'"

# 3. La preuve
if grep -qs "$jeton" "$(rc_home)/jeton.txt"; then
  ok "le jeton de session est dans ~/jeton.txt"
else
  ko "le jeton de session est dans ~/jeton.txt"
fi

rc_result
