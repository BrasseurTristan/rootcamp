#!/usr/bin/env bash
# Même réglage, écrit autrement : clé avec des « / » et variante conf.all.forwarding.
set -euo pipefail
sysctl -q -w net.ipv4.conf.all.forwarding=1
echo 'net/ipv4/conf/all/forwarding = 1' > /etc/sysctl.d/90-routage.conf
ip netns exec srv-bdd ip route add default via 10.20.0.1
