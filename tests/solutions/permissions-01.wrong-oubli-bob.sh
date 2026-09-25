#!/usr/bin/env bash
# Droits corrects, mais bob n'est toujours pas dans le groupe compta.
set -euo pipefail
chgrp -R compta /srv/compta
chmod 770 /srv/compta
chmod 660 /srv/compta/bilan-2025.txt
