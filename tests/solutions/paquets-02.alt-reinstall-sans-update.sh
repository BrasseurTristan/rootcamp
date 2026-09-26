#!/usr/bin/env bash
# Réinstallation directe, sans « apt update » : l'index du dépôt doit être à
# jour même après un reset (régression : « Hash Sum mismatch »).
set -euo pipefail
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --reinstall facturation-agent >/dev/null
