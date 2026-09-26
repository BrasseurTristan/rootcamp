#!/usr/bin/env bash
# « vagrant ssh » affiche 127.0.0.1:2222… mais c'est le port de TA machine :
# dans la VM, SSH écoute sur 22. Avec cette règle, plus personne n'entre.
set -euo pipefail
sed -i -e 's|^\(\s*\)tcp dport 3306 accept.*|\1tcp dport 8080 accept      # intranet|' \
       -e 's|tcp dport 22 accept|tcp dport 2222 accept|' /etc/nftables.conf
