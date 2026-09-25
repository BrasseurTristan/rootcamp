#!/usr/bin/env bash
# Le service tourne en root, sans compte dédié.
set -euo pipefail
sed -n '1,/^# Le pare-feu/p' "$(dirname "$0")/final-01.sh" \
  | sed -e '/^useradd/d' -e 's/^install -d -o carnet -g carnet/install -d -o root -g root/' -e '/^User=carnet/d' | bash
