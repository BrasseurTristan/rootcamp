Alerte de la supervision :

    [CRITIQUE] paiements : service instable (redémarre en boucle)

  Personne n'a touché au code. Le prestataire a juste « ajusté un
  paramètre » dans la configuration hier soir.

OBJECTIF

  - trouver dans le journal le message qui explique le plantage
  - corriger la cause
  - le service paiements tourne, et ne plante plus

POUR TESTER

    systemctl status paiements
