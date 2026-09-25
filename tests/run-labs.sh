#!/usr/bin/env bash
# Teste chaque lab qui a une solution dans tests/solutions/ :
#   1. après setup, le check doit échouer (le lab est bien cassé)
#   2. chaque <lab>.wrong-*.sh (mauvaise solution) doit faire échouer le check
#   3. après <lab>.sh (bonne solution), le check doit réussir
#
# À lancer en root dans une Debian 13 jetable (conteneur ou VM) où rootcamp est installé.
set -uo pipefail

cd "$(dirname "$0")/.." || exit 1
export RC_STATE
RC_STATE=$(mktemp -d)
failures=0

pass() { echo "  ✓ $*"; }
fail() { echo "  ✗ $*"; failures=$(( failures + 1 )); }

for solution in tests/solutions/*.sh; do
  [[ $solution == *.wrong-*.sh ]] && continue
  lab=$(basename "$solution" .sh)
  echo "== $lab"

  rootcamp start "$lab" >/dev/null || { fail "setup a échoué"; continue; }
  if rootcamp check >/dev/null; then fail "le check réussit avant toute correction"; else pass "le lab démarre cassé"; fi

  for wrong in tests/solutions/"$lab".wrong-*.sh; do
    [[ -e $wrong ]] || continue
    rootcamp reset >/dev/null
    bash "$wrong"
    if rootcamp check >/dev/null; then fail "$(basename "$wrong") est acceptée"; else pass "$(basename "$wrong") est refusée"; fi
  done

  rootcamp reset >/dev/null
  bash "$solution"
  if rootcamp check; then pass "la solution est acceptée"; else fail "la solution est refusée"; fi

  # Un reset doit remettre le lab dans son état cassé.
  rootcamp reset >/dev/null
  if rootcamp check >/dev/null; then fail "le reset ne remet pas le lab à zéro"; else pass "le reset remet le lab à zéro"; fi
done

echo
if (( failures )); then echo "$failures échec(s)"; exit 1; fi
echo "Tous les labs passent."
