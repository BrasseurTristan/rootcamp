#!/usr/bin/env bash
# La configuration est bonne, mais le serveur tourne encore avec l'ancienne.
dir=/etc/rootcamp/ssh/srv-web
sleep 1
printf 'PasswordAuthentication no\nPermitRootLogin no\n' > "$dir/sshd_config.d/10-migration.conf"
