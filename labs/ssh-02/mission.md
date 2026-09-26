Rapport d'audit sur le serveur web, srv-web (10.30.0.2) :

    De : Sécurité
    Objet : [AUDIT] SSH de srv-web

    1. Le serveur accepte les connexions par mot de passe : il subit
       des milliers de tentatives par jour (attaques par force brute).
    2. On peut se connecter directement en root.
    Merci de corriger. Les équipes se connectent avec des clés.

  Le serveur SSH de srv-web a sa propre configuration :

    configuration   /etc/rootcamp/ssh/srv-web/sshd_config
                    et /etc/rootcamp/ssh/srv-web/sshd_config.d/
    service         ssh-srv-web

  Ta clé pour le compte deploy : ~/.ssh/cle_deploy

OBJECTIF

  - les connexions par mot de passe sont refusées
  - personne ne peut se connecter directement en root, même avec une clé
  - deploy peut toujours se connecter avec sa clé (ne t'enferme pas
    dehors !)
  - la configuration est valide et appliquée

POUR TESTER

    ssh -o PubkeyAuthentication=no deploy@10.30.0.2   # doit être refusé
    ssh -i ~/.ssh/cle_deploy deploy@10.30.0.2         # doit marcher
