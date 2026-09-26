#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"

id deploy &>/dev/null || rc_die "L'utilisateur deploy a disparu ! Relance le lab avec 'rootcamp reset'."
[[ -x /usr/local/bin/deployer-appli ]] || rc_die "/usr/local/bin/deployer-appli a disparu ! Relance le lab avec 'rootcamp reset'."

if visudo -c &>/dev/null; then
  ok "la configuration de sudo est valide"
else
  ko "la configuration de sudo contient une erreur (lance 'sudo visudo -c')"
fi

password='Deploy2026!'
expect_ok "deploy peut lancer deployer-appli en root, sans mot de passe" \
  as_user deploy sudo -n /usr/local/bin/deployer-appli
expect_fail "deploy ne peut pas lancer d'autre commande en root (sans mot de passe)" \
  as_user deploy sudo -n id
expect_fail "deploy ne peut pas lancer d'autre commande en root (avec son mot de passe)" \
  as_user deploy sh -c "echo '$password' | sudo -S -k id"
expect_fail "deploy ne peut pas obtenir un shell root" \
  as_user deploy sh -c "echo '$password' | sudo -S -k -i true"
expect_fail "deploy ne fait plus partie du groupe sudo" \
  sh -c 'id -nG deploy | grep -qw sudo'

rc_result
