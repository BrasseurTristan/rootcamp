#!/usr/bin/env bash
# On tue l'indexeur… son parent le relance aussitôt.
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$(dirname "$0")/../../lib/lab.sh"
for p in $(rc_pids /opt/outils/indexeur); do kill "$p"; done
