#!/usr/bin/env bash
# La 2.2 est installée de force, mais le hold et l'épinglage sont toujours là.
apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --allow-change-held-packages --allow-downgrades facturation-agent=2.2
