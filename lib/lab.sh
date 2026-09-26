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
    rc_supprimer_user "$u"
  fi
  if _rc_owned "user:$u"; then
    # Son groupe personnel survit à userdel s'il a d'autres membres, et
    # userdel -r n'efface pas un dossier personnel qui ne lui appartient plus.
    if getent group "$u" >/dev/null; then
      groupdel -f "$u" || rc_die "Impossible de supprimer le groupe '$u'."
    fi
    rm -rf "/home/${u:?}" "/var/mail/${u:?}"
  fi
  useradd -m -s /bin/bash "$u"
  _rc_own "user:$u"
}

# rc_supprimer_user <nom> : arrête les processus d'un utilisateur puis le
# supprime (sans son dossier personnel). On vérifie qu'il a bien disparu :
# userdel échoue tant qu'un processus de l'utilisateur n'est pas terminé.
rc_supprimer_user() {
  local u=$1 _
  for _ in 1 2 3 4 5; do
    rc_kill_user "$u"
    userdel "$u" &>/dev/null || true
    id "$u" &>/dev/null || return 0
    sleep 0.5
  done
  rc_die "Impossible de supprimer l'utilisateur '$u' : des processus l'utilisent encore ($(rc_user_pids "$u" | tr '\n' ' '))."
}

# rc_user_pids <nom> : PID des processus de l'utilisateur. On compare les UID
# réel, effectif et sauvegardé (/proc/<pid>/status) : un « sudo » lancé par
# l'utilisateur appartient à root mais compte pour userdel.
rc_user_pids() {
  local uid p k r e s _
  uid=$(id -u "$1" 2>/dev/null) || return 0
  for p in /proc/[0-9]*; do
    while read -r k r e s _; do
      [[ $k == Uid: ]] || continue
      if [[ $r == "$uid" || $e == "$uid" || $s == "$uid" ]]; then echo "${p#/proc/}"; fi
      break
    done < "$p/status" 2>/dev/null
  done
  return 0
}

# rc_kill_user <nom> : tue tous les processus d'un utilisateur et attend
# qu'ils aient disparu (un processus peut en lancer un autre pendant le ménage).
rc_kill_user() {
  local uid pids _
  uid=$(id -u "$1" 2>/dev/null) || return 0
  systemctl kill --signal=KILL "user@$uid.service" &>/dev/null || true   # l'instance systemd --user
  systemctl stop "user@$uid.service" &>/dev/null || true
  for _ in 1 2 3 4 5 6 7 8 9 10; do
    pids=$(rc_user_pids "$1")
    [[ -n $pids ]] || return 0
    # shellcheck disable=SC2086
    kill -KILL $pids 2>/dev/null || true
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

# rc_pids <programme> : PID des processus qui exécutent ce programme (chemin
# complet), directement ou via un interpréteur (« sh /opt/outils/script »).
# Un « less /opt/outils/script » ouvert à côté ne compte pas.
rc_pids() {
  local p argv
  for p in /proc/[0-9]*; do
    [[ ${p#/proc/} == "$$" || ${p#/proc/} == "$BASHPID" ]] && continue
    mapfile -d '' -t argv < "$p/cmdline" 2>/dev/null || continue
    (( ${#argv[@]} )) || continue
    if [[ ${argv[0]} == "$1" ]] \
       || [[ ${argv[0]##*/} =~ ^(sh|dash|bash|python3?)$ && ${argv[1]:-} == "$1" ]]; then
      echo "${p#/proc/}"
    fi
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
