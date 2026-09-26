Tu dois te connecter au serveur web, srv-web (10.30.0.2), avec le
compte technique « deploy ». L'équipe t'a préparé une clé SSH :
~/.ssh/cle_deploy (sa partie publique a été installée sur srv-web).

    ssh -i ~/.ssh/cle_deploy deploy@10.30.0.2

  Mais ssh te demande un mot de passe... que personne ne connaît
  (et qu'il ne faut de toute façon pas utiliser).

  Tu as les droits root sur srv-web : les fichiers de ce serveur sont
  les mêmes que ceux de ta VM (même /home, même /etc/passwd), seul son
  service SSH est à part :

    configuration   /etc/rootcamp/ssh/srv-web/sshd_config
    service         ssh-srv-web       (journalctl -u ssh-srv-web)

OBJECTIF

  - « ssh -i ~/.ssh/cle_deploy deploy@10.30.0.2 » te connecte, sans
    mot de passe
  - sans désactiver les contrôles de sécurité du serveur SSH
