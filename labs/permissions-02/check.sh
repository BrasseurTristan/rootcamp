#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=../../lib/lab.sh
source "$RC_LIB/lab.sh"

dir=/srv/compta
[[ -d $dir ]] || rc_die "$dir a disparu ! Relance le lab avec 'rootcamp reset'."
for u in alice bob mallory; do
  id "$u" &>/dev/null || rc_die "L'utilisateur $u a disparu ! Relance le lab avec 'rootcamp reset'."
done
for f in relances.txt factures/f-2025-001.txt; do
  [[ -f $dir/$f ]] || rc_die "$dir/$f a disparu ! Relance le lab avec 'rootcamp reset'."
done

# Fichiers existants
expect_ok "bob peut modifier relances.txt (créé par alice)" as_user bob test -w "$dir/relances.txt"
expect_ok "alice peut créer un fichier dans factures/ (créé par bob)" \
  as_user alice sh -c 'f=/srv/compta/factures/.rc-$$; touch "$f" && rm -f "$f"'
expect_ok "alice peut modifier factures/f-2025-001.txt (créé par bob)" \
  as_user alice test -w "$dir/factures/f-2025-001.txt"

# Nouveaux fichiers, créés avec l'umask par défaut (022)
new_file=$dir/.rc-nouveau-fichier
new_dir=$dir/.rc-nouveau-dossier
new_facture=$dir/factures/.rc-nouvelle-facture
rm -rf "$new_file" "$new_dir" "$new_facture"
as_user alice sh -c "umask 022; echo test > $new_file" || true
as_user bob sh -c "umask 022; mkdir $new_dir" || true
as_user alice sh -c "umask 022; echo test > $new_facture" || true

if [[ -f $new_file && $(stat -c %G "$new_file") == compta ]]; then
  ok "un nouveau fichier créé par alice appartient au groupe compta"
else
  ko "un nouveau fichier créé par alice appartient au groupe compta"
fi
expect_ok "bob peut modifier un nouveau fichier créé par alice" as_user bob test -w "$new_file"
expect_ok "alice peut créer un fichier dans un nouveau dossier créé par bob" \
  as_user alice sh -c "umask 022; touch $new_dir/test"
if [[ -f $new_facture && $(stat -c %G "$new_facture") == compta ]] && as_user bob test -w "$new_facture"; then
  ok "une nouvelle facture créée par alice dans factures/ est modifiable par bob"
else
  ko "une nouvelle facture créée par alice dans factures/ est modifiable par bob"
fi
rm -rf "$new_file" "$new_dir" "$new_facture"

# Toujours fermé aux autres
expect_fail "mallory ne peut pas entrer dans $dir" as_user mallory ls "$dir"
if (( (8#$(stat -c %a "$dir") & 7) == 0 )); then
  ok "les autres utilisateurs n'ont aucun droit sur $dir"
else
  ko "les autres utilisateurs ont des droits sur $dir (trop permissif !)"
fi

rc_result
