Alerte de l'équipe sécurité :

    De : Sécurité
    Objet : [URGENT] Faille dans facturation-agent 2.1

    Une faille critique a été découverte dans facturation-agent 2.1.
    La version 2.2, qui la corrige, est disponible dans le dépôt
    interne. Merci de mettre à jour aujourd'hui.

  Un collègue a déjà essayé : « apt upgrade » ne fait rien pour ce
  paquet, sans message clair.

OBJECTIF

  - facturation-agent est en version 2.2
  - les PROCHAINES mises à jour de facturation-agent passeront
    normalement avec « apt upgrade » (rien ne le retient plus)

POUR TESTER

    sudo apt update
    apt policy facturation-agent
