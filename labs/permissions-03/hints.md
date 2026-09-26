Commence par comprendre d'où viennent les droits actuels de deploy :

    id deploy
    sudo -l -U deploy          # ce que sudo autorise pour deploy
    sudo cat /etc/sudoers      # cherche la ligne qui parle du groupe sudo
---
Une règle sudo se lit ainsi :

    QUI   OÙ = (EN TANT QUE QUI)   QUELLES COMMANDES
    %sudo ALL= (ALL:ALL)           ALL

Le % désigne un groupe. Il te faut une règle qui n'autorise qu'UNE
commande, et le mot-clé NOPASSWD: pour se passer du mot de passe.

Plutôt que de modifier /etc/sudoers, on ajoute un fichier dans
/etc/sudoers.d/. Attention : sudo IGNORE les fichiers de ce dossier
dont le nom contient un point (deploy.conf ne sera jamais lu !).
---
Les commandes utiles :

    sudo gpasswd -d deploy sudo            retirer deploy du groupe sudo
    sudo visudo -f /etc/sudoers.d/deploy   créer la règle en sécurité

avec une règle de la forme :

    deploy ALL=(root) NOPASSWD: /usr/local/bin/deployer-appli
