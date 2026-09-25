# shellcheck shell=bash
# Fonctions partagées par les setup.sh et check.sh des labs.
# Ces scripts tournent en root ; RC_USER contient l'utilisateur qui fait le lab.

if [[ -t 1 ]]; then
  _G=$'\e[32m' _R=$'\e[31m' _N=$'\e[0m'
else
  _G='' _R='' _N=''
fi

RC_OWNED=/var/lib/rootcamp/owned
RC_FAILED=0

rc_die() { echo "${_R}✗${_N} $*" >&2; exit 1; }

# --- Préparation (setup.sh) -------------------------------------------------

# rootcamp ne supprime que les utilisateurs et groupes qu'il a lui-même créés.
_rc_own()   { mkdir -p "${RC_OWNED%/*}"; grep -qxF "$1" "$RC_OWNED" 2>/dev/null || echo "$1" >> "$RC_OWNED"; }
_rc_owned() { grep -qxF "$1" "$RC_OWNED" 2>/dev/null; }

# rc_user <nom> : (re)crée un utilisateur de lab tout neuf.
rc_user() {
  local u=$1
  if id "$u" &>/dev/null; then
    _rc_owned "user:$u" || rc_die "L'utilisateur '$u' existe déjà et n'a pas été créé par rootcamp : je n'y touche pas."
    pkill -KILL -u "$u" 2>/dev/null || true
    userdel -r "$u" &>/dev/null || userdel "$u"
  fi
  useradd -m -s /bin/bash "$u"
  _rc_own "user:$u"
}

# rc_group <nom> : (re)crée un groupe de lab vide.
rc_group() {
  local g=$1
  if getent group "$g" >/dev/null; then
    _rc_owned "group:$g" || rc_die "Le groupe '$g' existe déjà et n'a pas été créé par rootcamp : je n'y touche pas."
    groupdel "$g"
  fi
  groupadd "$g"
  _rc_own "group:$g"
}

# --- Vérification (check.sh) ------------------------------------------------

ok() { echo "  ${_G}✓${_N} $*"; }
ko() { echo "  ${_R}✗${_N} $*"; RC_FAILED=1; }

# as_user <utilisateur> <commande…> : lance une commande avec les droits d'un utilisateur.
# Les groupes sont relus à chaque appel, comme lors d'une nouvelle connexion.
as_user() { local u=$1; shift; runuser -u "$u" -- "$@"; }

# expect_ok "<description>" <commande…> : la commande doit réussir.
expect_ok() {
  local desc=$1; shift
  if "$@" &>/dev/null; then ok "$desc"; else ko "$desc"; fi
}

# expect_fail "<description>" <commande…> : la commande doit échouer.
expect_fail() {
  local desc=$1; shift
  if "$@" &>/dev/null; then ko "$desc"; else ok "$desc"; fi
}

# À appeler à la fin de chaque check.sh.
rc_result() { exit "$RC_FAILED"; }
