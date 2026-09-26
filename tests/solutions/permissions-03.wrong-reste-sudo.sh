#!/usr/bin/env bash
# La règle est bonne, mais deploy est toujours dans le groupe sudo.
set -euo pipefail
echo 'deploy ALL=(root) NOPASSWD: /usr/local/bin/deployer-appli' > /etc/sudoers.d/deploy
chmod 440 /etc/sudoers.d/deploy
