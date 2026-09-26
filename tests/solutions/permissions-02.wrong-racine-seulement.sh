#!/usr/bin/env bash
# setgid et ACL par défaut posés sur /srv/compta seulement : le dossier
# factures/, qui existait déjà, n'en hérite pas.
set -euo pipefail
chgrp -R compta /srv/compta
chmod -R g+w /srv/compta
chmod g+s /srv/compta
setfacl -d -m g::rwx /srv/compta
