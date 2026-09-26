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
    local _
    for _ in 1 2 3; do
      rc_kill_user "$u"
      userdel -r "$u" &>/dev/null && break
      sleep 0.5
    done
    if id "$u" &>/dev/null; then userdel "$u"; fi
  fi
  useradd -m -s /bin/bash "$u"
  _rc_own "user:$u"
}

# rc_kill_user <nom> : tue tous les processus d'un utilisateur. On compare les
# UID réel, effectif et sauvegardé (/proc/<pid>/status) : un « sudo » lancé par
# l'utilisateur appartient à root mais compte pour userdel. On recommence tant
# qu'il en reste : un processus peut en lancer un autre pendant le ménage.
rc_kill_user() {
  local uid p found uids _
  uid=$(id -u "$1" 2>/dev/null) || return 0
  systemctl stop "user@$uid.service" &>/dev/null || true   # l'instance systemd --user
  for _ in 1 2 3 4 5 6 7 8 9 10; do
    found=0
    for p in /proc/[0-9]*; do
      uids=$(awk '/^Uid:/ {print $2, $3, $4}' "$p/status" 2>/dev/null) || continue
      if [[ " $uids " == *" $uid "* ]]; then
        kill -KILL "${p#/proc/}" 2>/dev/null && found=1
      fi
    done
    (( found )) || return 0
    sleep 0.2
  done
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

# --- Utilitaires -------------------------------------------------------------

# rc_home : dossier personnel de la personne qui fait le lab.
rc_home() { getent passwd "$RC_USER" | cut -d: -f6; }

# rc_pids <texte> : PID des processus dont la ligne de commande contient <texte>
# (comme « pgrep -f », sans dépendre de procps).
rc_pids() {
  local p cmd
  for p in /proc/[0-9]*; do
    [[ ${p#/proc/} == "$$" || ${p#/proc/} == "$BASHPID" ]] && continue
    cmd=$(tr '\0' ' ' < "$p/cmdline" 2>/dev/null) || continue
    [[ $cmd == *"$1"* ]] && echo "${p#/proc/}"
  done
  return 0
}

# rc_retry <secondes> <commande…> : réessaie la commande chaque seconde jusqu'à
# ce qu'elle réussisse (utile quand un service met un peu de temps à démarrer).
rc_retry() {
  local n=$1; shift
  until "$@" &>/dev/null; do
    (( n-- > 0 )) || return 1
    sleep 1
  done
}
