#!/usr/bin/env bash
# Retiré du groupe sudo… mais autorisé à tout faire sans mot de passe : pire qu'avant.
set -euo pipefail
gpasswd -d deploy sudo
echo 'deploy ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/deploy
chmod 440 /etc/sudoers.d/deploy
