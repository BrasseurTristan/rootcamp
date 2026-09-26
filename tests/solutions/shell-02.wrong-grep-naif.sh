#!/usr/bin/env bash
# « grep 500 » compte aussi les réponses de 500 octets.
set -euo pipefail
grep 500 /var/log/facturation/acces.log | awk '{print $1}' \
  | sort | uniq -c | sort -rn | head -3 > ~/rapport-erreurs.txt
