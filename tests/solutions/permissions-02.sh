#!/usr/bin/env bash
set -euo pipefail
chgrp -R compta /srv/compta
chmod g+w /srv/compta/relances.txt /srv/compta/factures/f-2025-001.txt
chmod g+rwxs /srv/compta/factures
chmod g+s /srv/compta
setfacl -d -m g::rwx /srv/compta
setfacl -d -m g::rwx /srv/compta/factures
