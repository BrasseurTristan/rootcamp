#!/usr/bin/env bash
# L'application marche… avec l'adresse en dur dans sa configuration.
set -euo pipefail
sed -i 's/^hote=.*/hote=10.20.0.2/' /etc/facturation/bdd.conf
