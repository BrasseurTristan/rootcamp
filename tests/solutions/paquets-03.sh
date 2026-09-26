#!/usr/bin/env bash
set -euo pipefail
apt-mark unhold facturation-agent
rm /etc/apt/preferences.d/facturation-agent
apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --only-upgrade facturation-agent
