#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"
# shellcheck source=../../lib/ssh.sh
source "$RC_LIB/ssh.sh"

ssh_verifier_machine srv-web

dir=$SSH_ETC/srv-web
key="$(rc_home)/.ssh/cle_deploy"
[[ -f $key && -f $dir/cle_root_admin ]] || rc_die "Des clés ont disparu ! Relance le lab avec 'rootcamp reset'."

expect_ok "la configuration du serveur SSH est valide (sshd -t)" sshd -t -f "$dir/sshd_config"
expect_ok "le serveur SSH de srv-web tourne" systemctl is-active --quiet ssh-srv-web

expect_fail "root ne peut pas se connecter en SSH, même avec une clé" \
  ssh_test root -i "$dir/cle_root_admin" root@10.30.0.2
expect_fail "les connexions par mot de passe sont refusées" \
  runuser -u "$RC_USER" -- sshpass -p 'Deploy2026!' ssh -o ConnectTimeout=5 \
    -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR \
    -o PubkeyAuthentication=no deploy@10.30.0.2 true
expect_ok "deploy se connecte toujours avec sa clé (tu ne t'es pas enfermé dehors)" \
  ssh_test "$RC_USER" -i "$key" deploy@10.30.0.2

rc_result
