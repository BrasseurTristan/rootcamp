Un message d'Alice (compta) :

    Objet : Mon site affiche « 403 Forbidden »
    J'ai préparé le petit site interne de la compta dans mon dossier
    perso, et le prestataire a configuré nginx pour le servir. Mais
    http://<le serveur>/ affiche « 403 Forbidden »...

  La règle de l'équipe infra : les sites web sont rangés dans
  /var/www/<nom du site>, JAMAIS dans le dossier personnel de quelqu'un.

OBJECTIF

  - http://localhost/ affiche l'Espace Compta
  - le site est servi depuis /var/www/compta
  - le dossier personnel d'alice reste privé
  - la configuration de nginx est valide

POUR TESTER

    curl -i http://localhost/
