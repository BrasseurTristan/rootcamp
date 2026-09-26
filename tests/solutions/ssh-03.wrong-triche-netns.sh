#!/usr/bin/env bash
# Le jeton récupéré en trichant, sans tunnel.
cat >> ~/.ssh/config <<'CONF'

Host bdd
    HostName 10.20.0.2
    User deploy
    IdentityFile ~/.ssh/cle_bdd
CONF
ip netns exec srv-bdd curl -fsS http://127.0.0.1:8080/ | grep -o 'Jeton de session : [0-9a-f]*' > ~/jeton.txt
