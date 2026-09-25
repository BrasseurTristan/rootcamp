#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$(dirname "$0")/../../lib/lab.sh"
for p in $(rc_pids /opt/outils/surveillant); do kill "$p"; done
sleep 0.5
for p in $(rc_pids /opt/outils/indexeur); do kill "$p"; done
sed -i '/surveillant/d' /var/spool/cron/crontabs/bob
