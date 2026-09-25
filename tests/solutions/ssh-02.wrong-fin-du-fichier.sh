#!/usr/bin/env bash
# Ajouté à la fin de sshd_config : ignoré, car la première valeur lue gagne.
dir=/etc/rootcamp/ssh/srv-web
printf '\nPasswordAuthentication no\nPermitRootLogin no\n' >> "$dir/sshd_config"
sleep 1
systemctl restart ssh-srv-web
sleep 1
