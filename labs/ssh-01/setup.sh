#!/usr/bin/env bash
# Casse : la connexion par clé échoue des deux côtés.
#  - côté serveur : ~deploy/.ssh est ouvert à tous, sshd refuse de lire la clé
#  - côté client : la clé privée est lisible par tout le monde, ssh l'ignore
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"
# shellcheck source=../../lib/reseau.sh
source "$RC_LIB/reseau.sh"
# shellcheck source=../../lib/ssh.sh
source "$RC_LIB/ssh.sh"

ssh_serveur srv-web 10.30.0.1 10.30.0.2
rc_user deploy
echo 'deploy:Deploy2026!' | chpasswd

key="$(rc_home)/.ssh/cle_deploy"
ssh_autoriser deploy "$(ssh_cle "$key")"

chmod 644 "$key"
chmod 777 /home/deploy/.ssh
chown root:root /home/deploy/.ssh/authorized_keys
chmod 666 /home/deploy/.ssh/authorized_keys

ssh_demarrer srv-web
