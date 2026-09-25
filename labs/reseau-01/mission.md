Le nouvel intranet de la compta vient d'être installé sur le serveur.

    De : Alice (compta)
    Objet : L'intranet ne marche pas

    Quand j'ouvre http://10.10.0.1:8080 depuis mon poste, j'ai
    « Connexion refusée ». Le prestataire jure que ça marchait chez
    lui, sur le serveur...

  Le poste d'Alice est simulé sur ce serveur. Pour lancer une commande
  « depuis son poste », préfixe-la par :

    sudo ip netns exec poste-alice <commande>

OBJECTIF

  - l'intranet répond depuis le poste d'Alice, sur http://10.10.0.1:8080
  - il est toujours lancé par le service systemd « intranet »,
    démarré et activé

POUR TESTER

    curl http://127.0.0.1:8080
    sudo ip netns exec poste-alice curl http://10.10.0.1:8080
