#!/usr/bin/env bash
# Prépare un journal d'accès web de plusieurs milliers de lignes. Rien n'est
# cassé : il faut en extraire une information avec des pipes.
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"

log=/var/log/facturation/acces.log
rm -f "$(rc_home)/rapport-erreurs.txt"
mkdir -p /var/log/facturation

RANDOM=2026   # même journal à chaque fois
pages=(/ /api/factures /api/clients /api/factures/export /connexion /tableau-de-bord)

# ligne <ip> <statut> <taille>
ligne() {
  printf '%s - - [25/Sep/2026:%02d:%02d:%02d +0200] "GET %s HTTP/1.1" %s %s\n' \
    "$1" $((RANDOM % 24)) $((RANDOM % 60)) $((RANDOM % 60)) "${pages[RANDOM % ${#pages[@]}]}" "$2" "$3"
}
# lignes <ip> <nombre> <statut> [taille]
lignes() {
  local i
  for ((i = 0; i < $2; i++)); do ligne "$1" "$3" "${4:-$((200 + RANDOM % 9000))}"; done
}

{
  # Les trois IP qui provoquent le plus d'erreurs 500
  lignes 198.51.100.23 57 500; lignes 198.51.100.23 40 200
  lignes 203.0.113.8   41 500; lignes 203.0.113.8   30 200
  lignes 192.0.2.77    33 500; lignes 192.0.2.77    20 200
  # Beaucoup de trafic, peu d'erreurs… et des réponses de 500 octets
  lignes 10.0.4.12 800 200; lignes 10.0.4.12 100 200 500; lignes 10.0.4.12 5 500
  lignes 10.0.4.13 700 200; lignes 10.0.4.13 3 500
  # Beaucoup de pages introuvables, mais ce ne sont pas des erreurs 500
  lignes 203.0.113.99 80 404
  # Le reste du trafic
  for n in $(seq 20 60); do
    lignes "10.0.8.$n" $((20 + RANDOM % 40)) 200
    lignes "10.0.8.$n" $((RANDOM % 15)) 500
    lignes "10.0.8.$n" $((RANDOM % 5)) 404
  done
} | shuf --random-source=<(yes) > "$log"
