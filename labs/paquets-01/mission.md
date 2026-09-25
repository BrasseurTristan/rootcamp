Demande de l'équipe compta :

    De : Alice (compta)
    Objet : Installer l'agent de facturation

    Bonjour,
    Il nous faut « facturation-agent » sur ce serveur. Il est dans le
    dépôt interne de la boîte, mais « apt install » répond qu'il ne
    connaît pas ce paquet...

  D'après le wiki de l'équipe infra :
    - le dépôt interne est dans /srv/depot-interne
    - sa clé publique de signature est /srv/depot-interne/cle-publique.asc

OBJECTIF

  - apt lit le dépôt interne sans erreur ni avertissement
  - la signature du dépôt est VÉRIFIÉE (pas question de désactiver la
    vérification avec « trusted=yes »)
  - le paquet facturation-agent est installé et fonctionne

POUR TESTER

    sudo apt update
    apt policy facturation-agent
    facturation-agent
