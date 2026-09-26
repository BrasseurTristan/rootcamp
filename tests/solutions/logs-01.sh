#!/usr/bin/env bash
set -euo pipefail
sed -i 's/^devise=.*/devise=EUR/' /etc/paiements/paiements.conf
systemctl restart paiements
