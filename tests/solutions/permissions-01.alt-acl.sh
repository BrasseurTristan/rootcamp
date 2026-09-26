#!/usr/bin/env bash
# Des ACL au lieu du groupe : bob n'entre pas dans compta, il reçoit des droits
# nominatifs.
set -euo pipefail
setfacl -m u:alice:rwx,u:bob:rwx /srv/compta
setfacl -m u:alice:rw,u:bob:rw /srv/compta/bilan-2025.txt
