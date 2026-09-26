#!/usr/bin/env bash
set -euo pipefail
dir=/etc/rootcamp/ssh/srv-web
printf 'PasswordAuthentication no\nPermitRootLogin no\n' > "$dir/sshd_config.d/10-migration.conf"
sshd -t -f "$dir/sshd_config"
sleep 1
systemctl restart ssh-srv-web
sleep 1
