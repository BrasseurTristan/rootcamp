#!/usr/bin/env bash
set -euo pipefail
awk '$9 == 500 {print $1}' /var/log/facturation/acces.log \
  | sort | uniq -c | sort -rn | head -3 | awk '{print $2}' > ~/rapport-erreurs.txt
