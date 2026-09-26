CE QUI ÉTAIT CASSÉ

  Deux fichiers du paquet facturation-agent avaient été abîmés :

    missing    /usr/bin/facturation-agent                        (supprimé)
    ??5??????  /usr/share/facturation-agent/modeles/facture.tpl  (modifié)

UNE SOLUTION

    dpkg -S /usr/bin/facturation-agent       # → facturation-agent
    dpkg --verify facturation-agent          # l'état des lieux
    sudo apt install --reinstall facturation-agent

POURQUOI ÇA MARCHE

  dpkg tient une base de données de tout ce qui est installé
  (/var/lib/dpkg/) : pour chaque paquet, la liste de ses fichiers et
  leur empreinte MD5. C'est ce qui permet de retrouver le paquet d'un
  fichier, de vérifier son intégrité, et de désinstaller proprement.

  « --reinstall » réinstalle la même version : tous les fichiers du
  paquet sont remis en place.

À RETENIR

  - dpkg : l'outil bas niveau (un .deb, la base locale).
    apt : par-dessus, gère les dépôts et les dépendances.
  - dpkg -S <fichier>   quel paquet l'a installé ?
    dpkg -L <paquet>    quels fichiers a-t-il installés ?
    dpkg --verify       quels fichiers ont été modifiés ?
  - Les fichiers de CONFIGURATION (dans /etc) sont un cas à part :
    dpkg ne les écrase pas à la réinstallation ou à la mise à jour, pour
    ne pas perdre tes réglages. Il te demande quoi faire s'ils ont changé.
  - Ne modifie jamais à la main les fichiers de /usr : ils appartiennent
    aux paquets et seront écrasés à la prochaine mise à jour.
