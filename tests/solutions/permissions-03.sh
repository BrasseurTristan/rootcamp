#!/usr/bin/env bash
set -euo pipefail
gpasswd -d deploy sudo
echo 'deploy ALL=(root) NOPASSWD: /usr/local/bin/deployer-appli' > /etc/sudoers.d/deploy
chmod 440 /etc/sudoers.d/deploy
visudo -c
