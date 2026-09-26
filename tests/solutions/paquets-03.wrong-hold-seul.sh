#!/usr/bin/env bash
# Le hold est retiré, mais l'épinglage garde la 2.1.
apt-mark unhold facturation-agent
apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --only-upgrade facturation-agent
