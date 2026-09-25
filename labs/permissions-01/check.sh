#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"

dir=/srv/compta
file=$dir/bilan-2025.txt

[[ -d $dir && -f $file ]] || rc_die "$dir ou bilan-2025.txt a disparu ! Relance le lab avec 'rootcamp reset'."
for u in alice bob mallory; do
  id "$u" &>/dev/null || rc_die "L'utilisateur $u a disparu ! Relance le lab avec 'rootcamp reset'."
done

for u in alice bob; do
  expect_ok "$u peut lister le contenu de $dir"   as_user "$u" ls "$dir"
  expect_ok "$u peut lire bilan-2025.txt"         as_user "$u" test -r "$file"
  expect_ok "$u peut modifier bilan-2025.txt"     as_user "$u" test -w "$file"
  expect_ok "$u peut créer un fichier dans $dir" \
    as_user "$u" sh -c 'f="$1/.rootcamp-check-$$"; touch "$f" && rm -f "$f"' _ "$dir"
done

expect_fail "mallory ne peut pas entrer dans $dir" as_user mallory ls "$dir"
expect_fail "mallory ne peut pas lire bilan-2025.txt" as_user mallory cat "$file"
expect_fail "mallory ne fait pas partie de l'équipe compta" sh -c 'id -nG mallory | grep -qw compta'

if (( (8#$(stat -c %a "$dir") & 7) == 0 )); then
  ok "les autres utilisateurs n'ont aucun droit sur $dir"
else
  ko "les autres utilisateurs ont encore des droits sur $dir (trop permissif !)"
fi

rc_result
