# shellcheck shell=bash
# Des serveurs SSH « distants » : un vrai sshd qui tourne dans une machine
# simulée (netns), avec sa propre configuration. Le SSH de la VM n'est jamais
# touché : impossible de s'enfermer dehors.
# À charger après lib/reseau.sh.

SSH_ETC=/etc/rootcamp/ssh

# ssh_serveur <machine> <ip du serveur> <ip de la machine>
# (Re)crée la machine et la configuration de son serveur SSH :
#   configuration  $SSH_ETC/<machine>/sshd_config (+ sshd_config.d/*.conf)
#   service        ssh-<machine>
ssh_serveur() {
  local m=$1 dir="$SSH_ETC/$1"
  systemctl stop "ssh-$m" &>/dev/null || true
  systemctl reset-failed "ssh-$m" &>/dev/null || true
  reseau_machine "$m" "$2" "$3"
  rm -rf "$dir"
  mkdir -p "$dir/sshd_config.d"
  ssh-keygen -q -t ed25519 -N '' -C "$m" -f "$dir/ssh_host_ed25519_key"
  cat > "$dir/sshd_config" <<CONF
# Configuration du serveur SSH de la machine $m
#
# ATTENTION : pour chaque réglage, sshd garde la PREMIÈRE valeur qu'il lit.
# Les fichiers de sshd_config.d/ sont lus en premier (ligne Include).

Include $dir/sshd_config.d/*.conf

HostKey $dir/ssh_host_ed25519_key
PidFile /run/sshd-$m.pid

KbdInteractiveAuthentication no
UsePAM yes
PrintMotd no
Subsystem sftp /usr/lib/openssh/sftp-server
CONF
  cat > "/etc/systemd/system/ssh-$m.service" <<UNIT
[Unit]
Description=Serveur SSH de la machine $m
After=network.target

[Service]
ExecStartPre=/usr/sbin/sshd -t -f $dir/sshd_config
ExecStart=/usr/sbin/ip netns exec $m /usr/sbin/sshd -D -e -f $dir/sshd_config
ExecReload=/usr/sbin/sshd -t -f $dir/sshd_config
ExecReload=/bin/kill -HUP \$MAINPID
RuntimeDirectory=sshd
RuntimeDirectoryPreserve=yes
UNIT
  systemctl daemon-reload
}

# ssh_demarrer <machine> : démarre son serveur SSH et attend qu'il écoute.
ssh_demarrer() {
  systemctl restart "ssh-$1"
  rc_retry 10 sh -c "ip netns exec $1 ss -Htln 'sport = :22' | grep -q ."
}

# ssh_cle <fichier> : crée une paire de clés (sans phrase de passe) pour
# RC_USER, avec les bons droits. Affiche la clé publique.
ssh_cle() {
  local f=$1 dir
  dir=$(dirname "$f")
  mkdir -p "$dir"
  chown "$RC_USER": "$dir"
  chmod 700 "$dir"
  rm -f "$f" "$f.pub"
  ssh-keygen -q -t ed25519 -N '' -C "cle-rootcamp" -f "$f"
  chown "$RC_USER": "$f" "$f.pub"
  cat "$f.pub"
}

# ssh_autoriser <utilisateur> <clé publique> : autorise la clé pour cet
# utilisateur (~/.ssh/authorized_keys, avec les bons droits).
ssh_autoriser() {
  local u=$1 home
  home=$(getent passwd "$u" | cut -d: -f6)
  mkdir -p "$home/.ssh"
  echo "$2" > "$home/.ssh/authorized_keys"
  chown -R "$u": "$home/.ssh"
  chmod 700 "$home/.ssh"
  chmod 600 "$home/.ssh/authorized_keys"
}

# ssh_test <utilisateur local> <options ssh…> : tente une connexion sans
# interaction (réussit si la commande « true » a pu être lancée à distance).
ssh_test() {
  local u=$1; shift
  runuser -u "$u" -- ssh -o BatchMode=yes -o ConnectTimeout=5 \
    -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR "$@" true
}
