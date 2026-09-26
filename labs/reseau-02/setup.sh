#!/usr/bin/env bash
# Casse : une vieille entrée de /etc/hosts envoie db.interne vers l'ancien
# serveur de base de données, qui n'existe plus.
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"
# shellcheck source=../../lib/reseau.sh
source "$RC_LIB/reseau.sh"

reseau_parefeu_ouvert

reseau_machine srv-bdd 10.20.0.1 10.20.0.2
reseau_service rc-bdd ip netns exec srv-bdd nc -lk 5432

# Réécriture « en place » (sans sed -i) : /etc/hosts peut être un point de
# montage (conteneurs), qu'on ne peut pas remplacer par un nouveau fichier.
hosts=$(grep -v 'db\.interne' /etc/hosts)
printf '%s\n10.20.0.99      db.interne\n' "$hosts" > /etc/hosts

mkdir -p /etc/facturation
cat > /etc/facturation/bdd.conf <<'CONF'
# Connexion à la base de données
hote=db.interne
port=5432
CONF
cat > /usr/local/bin/test-bdd <<'SCRIPT'
#!/bin/sh
# Vérifie que l'application peut joindre sa base de données.
. /etc/facturation/bdd.conf
if nc -z -w 3 "$hote" "$port" 2>/dev/null; then
  echo "OK : la base $hote:$port répond"
else
  echo "ERREUR : impossible de joindre la base $hote:$port" >&2
  exit 1
fi
SCRIPT
chmod 755 /usr/local/bin/test-bdd
