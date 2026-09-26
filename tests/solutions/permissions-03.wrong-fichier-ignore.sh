#!/usr/bin/env bash
# Le fichier contient un point dans son nom : sudo l'ignore.
set -euo pipefail
gpasswd -d deploy sudo
echo 'deploy ALL=(root) NOPASSWD: /usr/local/bin/deployer-appli' > /etc/sudoers.d/deploy.conf
chmod 440 /etc/sudoers.d/deploy.conf
