#!/usr/bin/env bash
# Le tunnel marche, mais sans l'alias demandé.
ssh -f -N -o StrictHostKeyChecking=accept-new -i ~/.ssh/cle_bdd -L 9000:127.0.0.1:8080 deploy@10.20.0.2
sleep 1
curl -fsS http://127.0.0.1:9000/ | grep -o 'Jeton de session : [0-9a-f]*' > ~/jeton.txt
