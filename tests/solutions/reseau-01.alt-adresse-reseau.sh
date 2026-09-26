#!/usr/bin/env bash
# L'intranet n'écoute que sur l'adresse du réseau d'Alice (proposé par l'indice 3).
set -euo pipefail
sed -i 's/^ADRESSE=.*/ADRESSE=10.10.0.1/' /etc/intranet.conf
systemctl enable intranet
systemctl restart intranet
