#!/usr/bin/env bash
# Le routage est actif, mais srv-bdd ne sait pas renvoyer ses réponses.
sysctl -q -w net.ipv4.ip_forward=1
echo 'net.ipv4.ip_forward = 1' > /etc/sysctl.d/90-routage.conf
