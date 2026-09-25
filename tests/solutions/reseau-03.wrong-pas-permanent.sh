#!/usr/bin/env bash
# Tout marche… jusqu'au prochain redémarrage.
sysctl -q -w net.ipv4.ip_forward=1
ip netns exec srv-bdd ip route add default via 10.20.0.1
