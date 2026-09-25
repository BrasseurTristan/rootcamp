Un ticket de l'équipe sécurité :

    De : Sécurité
    Objet : Audit — compte « deploy » beaucoup trop puissant

    Bonjour,
    L'audit a relevé que le compte technique « deploy », utilisé par
    l'outil de déploiement, est membre du groupe sudo : quiconque vole
    son mot de passe devient root sur le serveur.
    Or ce compte n'a besoin que d'une seule chose : lancer
    /usr/local/bin/deployer-appli en root.
    Merci de corriger sans casser les déploiements.

OBJECTIF

  - deploy peut lancer « sudo /usr/local/bin/deployer-appli »,
    SANS mot de passe (l'outil de déploiement ne peut pas en taper)
  - deploy ne peut RIEN faire d'autre en root, même avec son mot de
    passe (qui est Deploy2026!)
  - deploy ne fait plus partie du groupe sudo
  - la configuration de sudo reste valide

POUR TESTER

    sudo -u deploy sudo -n /usr/local/bin/deployer-appli
    sudo -u deploy sudo -n id        # doit être refusé

ATTENTION

  Une erreur dans la configuration de sudo peut te bloquer l'accès
  root. Utilise toujours visudo, qui vérifie la syntaxe avant
  d'enregistrer.
