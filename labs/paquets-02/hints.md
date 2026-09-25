Le système de paquets garde la trace de chaque fichier installé.
Quel paquet a installé cette commande ? Même supprimé, un fichier
reste connu de dpkg :

    dpkg -S /usr/bin/facturation-agent
---
dpkg sait lister les fichiers d'un paquet, et vérifier s'ils ont été
modifiés ou supprimés depuis l'installation :

    dpkg -L facturation-agent       la liste des fichiers
    dpkg --verify facturation-agent les fichiers abîmés ou manquants

Dans la sortie de --verify, un « 5 » signifie que le contenu du fichier
a changé (son empreinte MD5 ne correspond plus).
---
Plutôt que de recréer les fichiers à la main, on réinstalle le paquet :

    sudo apt update
    sudo apt install --reinstall facturation-agent

Puis vérifie à nouveau avec dpkg --verify (aucune sortie = tout va bien).
