#!/usr/bin/env bash
set -euo pipefail
sed -i 's|^\(\s*\)tcp dport 3306 accept.*|\1tcp dport 8080 accept      # intranet|' /etc/nftables.conf
nft -c -f /etc/nftables.conf
systemctl restart nftables
