#!/usr/bin/env bash
# Casse : le dossier de la compta appartient à root et est fermé à tous,
# et bob n'a jamais été ajouté au groupe compta.
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"

rc_user alice
rc_user bob
rc_user mallory
rc_group compta
usermod -aG compta alice

rm -rf /srv/compta
mkdir -p /srv/compta
cat > /srv/compta/bilan-2025.txt <<'EOF'
BILAN 2025 — CONFIDENTIEL
Chiffre d'affaires : 1 284 000 €
Résultat net : 96 500 €
EOF
chown -R root:root /srv/compta
chmod 700 /srv/compta
chmod 600 /srv/compta/bilan-2025.txt
