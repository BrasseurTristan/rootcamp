Commence par l'état des lieux :

    sudo apt update
    apt list --upgradable
    apt policy facturation-agent

Quelle version est installée ? Laquelle est disponible ? Laquelle
apt choisirait (« Candidate ») ?
---
Deux mécanismes peuvent empêcher la mise à jour d'un paquet :

  1. le « hold » : on marque le paquet pour qu'apt n'y touche plus
        apt-mark showhold
  2. l'épinglage (pinning) : des règles de priorité dans
     /etc/apt/preferences.d/ qui forcent une version

Dans « apt policy », les priorités sont indiquées devant chaque
version. Une priorité supérieure à 1000 force une version, même plus
ancienne.
---
Les commandes utiles :

    sudo apt-mark unhold facturation-agent
    ls /etc/apt/preferences.d/
    sudo rm /etc/apt/preferences.d/<le fichier d'épinglage>
    sudo apt update
    sudo apt install --only-upgrade facturation-agent
