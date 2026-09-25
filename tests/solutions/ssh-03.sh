#!/usr/bin/env bash
set -euo pipefail
cat >> ~/.ssh/config <<'CONF'

Host bdd
    HostName 10.20.0.2
    User deploy
    IdentityFile ~/.ssh/cle_bdd
    StrictHostKeyChecking accept-new
CONF
chmod 600 ~/.ssh/config
ssh -f -N -L 9000:127.0.0.1:8080 bdd
sleep 1
curl -fsS http://127.0.0.1:9000/ | grep -o 'Jeton de session : [0-9a-f]*' > ~/jeton.txt
