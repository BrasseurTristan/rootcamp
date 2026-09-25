#!/usr/bin/env bash
set -euo pipefail
sysctl -q -w net.ipv4.ip_forward=1
echo 'net.ipv4.ip_forward = 1' > /etc/sysctl.d/90-routage.conf
ip netns exec srv-bdd ip route add default via 10.20.0.1
