#!/usr/bin/env bash
set -euo pipefail
chgrp -R compta /srv/compta
chmod 770 /srv/compta
chmod 660 /srv/compta/bilan-2025.txt
usermod -aG compta bob
