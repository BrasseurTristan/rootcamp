#!/usr/bin/env bash
# SSH réservé au réseau des postes : la connexion depuis ta machine (Vagrant)
# ne vient pas de ce réseau, elle serait coupée.
set -euo pipefail
sed -i -e 's|^\(\s*\)tcp dport 3306 accept.*|\1tcp dport 8080 accept      # intranet|' \
       -e 's|tcp dport 22 accept|ip saddr 10.10.0.0/24 tcp dport 22 accept|' /etc/nftables.conf
