#!/usr/bin/env bash
# La méthode des vieux tutos : /etc/sysctl.conf… que Debian 13 ne lit plus
# au démarrage.
sysctl -q -w net.ipv4.ip_forward=1
echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf
ip netns exec srv-bdd ip route add default via 10.20.0.1
