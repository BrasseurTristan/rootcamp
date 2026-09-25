#!/usr/bin/env bash
# Plus de mots de passe… mais root peut toujours se connecter avec une clé.
dir=/etc/rootcamp/ssh/srv-web
printf 'PasswordAuthentication no\nPermitRootLogin prohibit-password\n' > "$dir/sshd_config.d/10-migration.conf"
sleep 1
systemctl restart ssh-srv-web
sleep 1
