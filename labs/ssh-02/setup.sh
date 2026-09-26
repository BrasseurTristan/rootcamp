#!/usr/bin/env bash
# Casse : le serveur SSH de srv-web accepte les mots de passe et la connexion
# directe en root, via un vieux fichier de sshd_config.d/ lu en premier.
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"
# shellcheck source=../../lib/reseau.sh
source "$RC_LIB/reseau.sh"
# shellcheck source=../../lib/ssh.sh
source "$RC_LIB/ssh.sh"

ssh_serveur srv-web 10.30.0.1 10.30.0.2
dir=$SSH_ETC/srv-web
rc_user deploy
echo 'deploy:Deploy2026!' | chpasswd

key="$(rc_home)/.ssh/cle_deploy"
ssh_autoriser deploy "$(ssh_cle "$key")"
chmod 600 "$key"

# Les clés de root sur srv-web sont à part (pas celles de ta VM !).
mkdir -p "$dir/cles"
ssh-keygen -q -t ed25519 -N '' -C root-admin -f "$dir/cle_root_admin"
cp "$dir/cle_root_admin.pub" "$dir/cles/root"
cat >> "$dir/sshd_config" <<CONF

AuthorizedKeysFile .ssh/authorized_keys $dir/cles/%u
CONF

cat > "$dir/sshd_config.d/10-migration.conf" <<'CONF'
# Ajouté pendant la migration de 2023, « temporairement »
PasswordAuthentication yes
PermitRootLogin yes
CONF
cat >> "$dir/sshd_config" <<'CONF'

# Sécurité
PermitRootLogin prohibit-password
CONF

ssh_demarrer srv-web
