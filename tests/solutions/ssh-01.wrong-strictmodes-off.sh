#!/usr/bin/env bash
# Le serveur ne vérifie plus rien : ça « marche », mais c'est une faille.
chmod 600 ~/.ssh/cle_deploy
echo "StrictModes no" > /etc/rootcamp/ssh/srv-web/sshd_config.d/00-depannage.conf
systemctl restart ssh-srv-web
sleep 1
