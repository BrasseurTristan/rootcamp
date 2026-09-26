#!/usr/bin/env bash
# Installe rootcamp dans une Debian 13.
#
#   curl -fsSL https://raw.githubusercontent.com/BrasseurTristan/rootcamp/main/install.sh | sudo bash
#
# Variables optionnelles :
#   RC_SOURCE=/chemin   utilise une copie locale du dépôt au lieu de cloner
#   RC_REPO, RC_BRANCH  dépôt et branche à cloner
set -euo pipefail

RC_REPO=${RC_REPO:-https://github.com/BrasseurTristan/rootcamp.git}
RC_BRANCH=${RC_BRANCH:-main}
RC_DIR=/opt/rootcamp

[[ $EUID -eq 0 ]] || { echo "Lance ce script en root (avec sudo)." >&2; exit 1; }

# shellcheck source=/dev/null
. /etc/os-release
[[ ${ID:-} == debian ]] || { echo "rootcamp est prévu pour Debian (détecté : ${PRETTY_NAME:-inconnu})." >&2; exit 1; }
[[ ${VERSION_ID:-} == 13 ]] || echo "Attention : rootcamp est testé sur Debian 13, tu as ${PRETTY_NAME}."

echo "==> Installation des dépendances…"
# Une source APT cassée (un lab du module 04 abandonné en cours…) ne doit pas
# empêcher l'installation : on prévient et on continue.
apt-get update -qq || echo "Attention : « apt-get update » a signalé des erreurs, on continue."
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq git sudo acl procps >/dev/null

if [[ -n ${RC_SOURCE:-} ]]; then
  echo "==> Utilisation de la copie locale $RC_SOURCE…"
  [[ -e $RC_DIR && ! -L $RC_DIR ]] && { echo "$RC_DIR existe déjà et n'est pas un lien." >&2; exit 1; }
  ln -sfn "$(readlink -f "$RC_SOURCE")" "$RC_DIR"
elif [[ -d $RC_DIR/.git ]]; then
  echo "==> Mise à jour de $RC_DIR…"
  git -C "$RC_DIR" pull --ff-only
else
  echo "==> Téléchargement de rootcamp…"
  git clone --quiet --depth 1 --branch "$RC_BRANCH" "$RC_REPO" "$RC_DIR"
fi

ln -sf "$RC_DIR/bin/rootcamp" /usr/local/bin/rootcamp
mkdir -p /var/lib/rootcamp

# Paquets demandés par les labs (champ « packages » des lab.yaml), installés
# d'avance pour que les labs démarrent vite, même sans réseau.
mapfile -t lab_packages < <(sed -En 's/[[:space:]]+#.*$//; s/^packages:[[:space:]]*//p' "$RC_DIR"/labs/*/lab.yaml \
  | tr ' ' '\n' | sed '/^$/d' | sort -u)
if (( ${#lab_packages[@]} )); then
  echo "==> Installation des outils utilisés par les labs…"
  DEBIAN_FRONTEND=noninteractive apt-get install -y -qq "${lab_packages[@]}" >/dev/null
fi

cat <<'EOF'

  rootcamp est installé !

  Tape « rootcamp list » pour voir les labs, puis « rootcamp start <lab> ».

  ⚠  Les labs cassent volontairement la machine :
     n'installe jamais rootcamp sur un vrai serveur.

EOF
