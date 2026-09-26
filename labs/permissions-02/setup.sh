#!/usr/bin/env bash
# Casse : le dossier est bien partagé, mais chaque fichier créé appartient au
# groupe personnel de son auteur avec les droits 644 : les collègues ne peuvent
# pas le modifier.
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"

rc_user alice
rc_user bob
rc_user mallory
rc_group compta
usermod -aG compta alice
usermod -aG compta bob

rm -rf /srv/compta
mkdir -p /srv/compta
chown root:compta /srv/compta
chmod 770 /srv/compta

echo "BILAN 2025 — CONFIDENTIEL" > /srv/compta/bilan-2025.txt
chown root:compta /srv/compta/bilan-2025.txt
chmod 660 /srv/compta/bilan-2025.txt

# Fichiers créés « normalement » par alice et bob, avec l'umask par défaut.
as_user alice sh -c 'umask 022; echo "Relances clients de septembre" > /srv/compta/relances.txt'
as_user bob   sh -c 'umask 022; mkdir /srv/compta/factures; echo "F-2025-001 : 1 200 €" > /srv/compta/factures/f-2025-001.txt'
