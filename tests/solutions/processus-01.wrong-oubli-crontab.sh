#!/usr/bin/env bash
# Réglé… jusqu'au prochain redémarrage.
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$(dirname "$0")/../../lib/lab.sh"
for p in $(rc_pids /opt/outils/surveillant); do kill "$p"; done
sleep 0.5
for p in $(rc_pids /opt/outils/indexeur); do kill "$p"; done
