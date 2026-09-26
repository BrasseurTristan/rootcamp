#!/usr/bin/env bash
# Bob ajouté au groupe personnel d'alice : discutable, mais ça marche. Au
# reset, le groupe « alice » a un autre membre et survit à userdel : rootcamp
# doit quand même recréer alice (régression : tous les resets échouaient).
set -euo pipefail
chgrp -R alice /srv/compta
chmod 770 /srv/compta
chmod 660 /srv/compta/bilan-2025.txt
usermod -aG alice bob
