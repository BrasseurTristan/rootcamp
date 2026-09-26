#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"
# shellcheck source=../../lib/ssh.sh
source "$RC_LIB/ssh.sh"

ssh_verifier_machine srv-web

key="$(rc_home)/.ssh/cle_deploy"
[[ -f $key ]] || rc_die "La clé $key a disparu ! Relance le lab avec 'rootcamp reset'."
id deploy &>/dev/null || rc_die "L'utilisateur deploy a disparu ! Relance le lab avec 'rootcamp reset'."

if (( (8#$(stat -c %a "$key") & 077) == 0 )); then
  ok "ta clé privée n'est lisible que par toi"
else
  ko "ta clé privée n'est lisible que par toi"
fi
effective=$(sshd -T -f "$SSH_ETC/srv-web/sshd_config" 2>/dev/null || true)
if grep -qx 'strictmodes yes' <<<"$effective"; then
  ok "le serveur vérifie toujours les droits des fichiers de clés (StrictModes)"
else
  ko "le serveur vérifie toujours les droits des fichiers de clés (StrictModes)"
fi
expect_ok "le serveur SSH de srv-web tourne" systemctl is-active --quiet ssh-srv-web
expect_ok "tu te connectes à deploy@10.30.0.2 avec ta clé, sans mot de passe" \
  ssh_test "$RC_USER" -i "$key" deploy@10.30.0.2

rc_result
