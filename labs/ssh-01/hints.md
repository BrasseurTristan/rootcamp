Demande à ssh de raconter ce qu'il fait :

    ssh -v -i ~/.ssh/cle_deploy deploy@10.30.0.2

Lis les premières lignes : un avertissement concerne ta clé...

Et côté serveur, que disent les logs ?

    sudo journalctl -u ssh-srv-web -n 20
---
Deux problèmes, un de chaque côté :

  - Côté client : ssh refuse d'utiliser une clé privée que d'autres
    peuvent lire (« UNPROTECTED PRIVATE KEY FILE »).
  - Côté serveur : sshd refuse les clés si le dossier ~/.ssh ou le
    fichier authorized_keys peuvent être modifiés par quelqu'un d'autre
    que leur propriétaire (option StrictModes, activée par défaut).

    ls -l ~/.ssh/cle_deploy
    sudo ls -la /home/deploy/.ssh
---
    chmod 600 ~/.ssh/cle_deploy

    sudo chown -R deploy:deploy /home/deploy/.ssh
    sudo chmod 700 /home/deploy/.ssh
    sudo chmod 600 /home/deploy/.ssh/authorized_keys
