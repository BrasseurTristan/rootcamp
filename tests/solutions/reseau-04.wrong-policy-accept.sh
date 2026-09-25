#!/usr/bin/env bash
# Tout est ouvert sauf la base : les autres services sont exposés.
set -euo pipefail
sed -i -e 's/policy drop;/policy accept;/' -e 's|^\(\s*\)tcp dport 3306 accept.*|\1tcp dport 3306 drop|' /etc/nftables.conf
systemctl restart nftables
