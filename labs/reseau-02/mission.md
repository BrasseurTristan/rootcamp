Ticket de l'équipe dev :

    De : Équipe dev
    Objet : L'appli ne trouve plus sa base

    Depuis la migration de la base de données sur le nouveau serveur
    (10.20.0.2) la semaine dernière, l'application de facturation de
    ce serveur n'arrive plus à s'y connecter. Les autres serveurs n'ont
    aucun problème. L'équipe réseau jure que tout est à jour de son côté.

  L'application se connecte à « db.interne », port 5432. La commande
  test-bdd vérifie la connexion comme le fait l'application.

OBJECTIF

  - db.interne désigne le nouveau serveur, 10.20.0.2
  - test-bdd réussit
  - l'application utilise toujours le NOM db.interne (mettre l'adresse
    IP en dur dans sa configuration n'est pas une solution)
