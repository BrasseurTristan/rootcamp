#!/usr/bin/env bash
set -euo pipefail
apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --reinstall facturation-agent
