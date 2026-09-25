#!/usr/bin/env bash
set -euo pipefail
chmod 600 ~/.ssh/cle_deploy
chown -R deploy:deploy /home/deploy/.ssh
chmod 700 /home/deploy/.ssh
chmod 600 /home/deploy/.ssh/authorized_keys
