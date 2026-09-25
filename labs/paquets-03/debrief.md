CE QUI ÉTAIT CASSÉ

  facturation-agent était bloqué deux fois :

    apt-mark hold facturation-agent        → apt ne le met plus à jour
    /etc/apt/preferences.d/facturation-agent
      Pin: version 2.1
      Pin-Priority: 1001                   → apt préfère la 2.1, même
                                             si une 2.2 existe

  Retirer un seul des deux ne suffisait pas : c'est souvent comme ça
  qu'on perd une heure !

UNE SOLUTION

    sudo apt-mark unhold facturation-agent
    sudo rm /etc/apt/preferences.d/facturation-agent
    sudo apt update
    sudo apt install --only-upgrade facturation-agent

POURQUOI ÇA MARCHE

  Pour chaque paquet, apt choisit un « candidat » : la version de plus
  haute PRIORITÉ (puis la plus récente à priorité égale). Par défaut,
  les dépôts ont la priorité 500 et la version installée 100. Une
  règle d'épinglage à 1001 bat tout le monde, et peut même provoquer
  un retour à une version plus ancienne.

  Le hold, lui, est une simple marque dans la base de dpkg : « ne
  touche pas à ce paquet ». apt upgrade l'ignore alors en silence (ou
  presque : « les paquets suivants ont été conservés »).

À RETENIR

  - « apt policy <paquet> » explique TOUJOURS le choix d'apt : versions,
    priorités, dépôts. Premier réflexe.
  - apt-mark hold/unhold/showhold pour geler un paquet.
  - Un blocage de version doit être documenté (ticket, commentaire) et
    avoir une date de fin, sinon on l'oublie... jusqu'à la faille.
  - Sur Debian, les mises à jour de sécurité peuvent être installées
    automatiquement avec le paquet unattended-upgrades.
