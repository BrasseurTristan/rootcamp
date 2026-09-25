#!/usr/bin/env bash
# Les IP les plus actives, pas celles qui provoquent le plus d'erreurs.
set -euo pipefail
awk '{print $1}' /var/log/facturation/acces.log \
  | sort | uniq -c | sort -rn | head -3 > ~/rapport-erreurs.txt
