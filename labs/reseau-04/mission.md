Deux tickets le même matin :

    De : Alice (compta)
    Objet : Intranet toujours inaccessible
    http://10.10.0.1:8080 ne répond pas depuis mon poste (ça tourne
    dans le vide puis erreur).

    De : Sécurité
    Objet : [AUDIT] Base de données exposée
    Le scan du réseau montre que le port 3306 (base de données) de ce
    serveur est accessible depuis les postes de travail. Il ne doit
    être joignable que depuis le serveur lui-même.

  Le pare-feu du serveur est géré avec nftables. Sa configuration est
  dans /etc/nftables.conf.

OBJECTIF

  - depuis le poste d'Alice : l'intranet (8080) répond, la base de
    données (3306) ne répond PAS
  - tout ce qui n'est pas explicitement autorisé reste bloqué
  - SSH reste autorisé (ne te coupe pas l'accès !)
  - la configuration est permanente : elle survit à un redémarrage

POUR TESTER

    sudo ip netns exec poste-alice curl -m 3 http://10.10.0.1:8080
    sudo ip netns exec poste-alice nc -zv -w 2 10.10.0.1 3306
