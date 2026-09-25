Alerte de la supervision :

    [CRITIQUE] facturation-api : service arrêté sur srv-compta-01

  Le développeur a livré l'API de facturation hier soir, avec son
  fichier d'unité systemd. Il est parti en congés ce matin...

OBJECTIF

  - le service facturation-api est démarré et fonctionne
  - il tourne avec l'utilisateur « facturation », pas en root
  - il redémarrera tout seul si le serveur redémarre
  - tu as corrigé l'unité existante (pas besoin d'en créer une autre)

POUR TESTER

    systemctl status facturation-api
    cat /run/facturation/battement      # mis à jour toutes les 2 s
