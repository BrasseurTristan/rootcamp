CE QUI ÉTAIT CASSÉ

  Dans /etc/apt/sources.list.d/depot-interne.sources :

    URIs: file:/srv/depot_interne          → le dossier s'appelle depot-interne
    Signed-By: /usr/share/keyrings/...gpg  → cette clé n'existait pas

UNE SOLUTION

    sudo cp /srv/depot-interne/cle-publique.asc /etc/apt/keyrings/depot-interne.asc

  puis dans le fichier .sources :

    URIs: file:/srv/depot-interne
    Signed-By: /etc/apt/keyrings/depot-interne.asc

  et enfin :

    sudo apt update && sudo apt install facturation-agent

POURQUOI ÇA MARCHE

  apt install ne cherche pas les paquets sur Internet au moment de
  l'installation : il consulte une LISTE locale des paquets
  disponibles, mise à jour par « apt update » à partir des dépôts
  déclarés dans /etc/apt/sources.list.d/.

  Chaque dépôt publie un index (InRelease) signé avec sa clé privée.
  apt vérifie cette signature avec la clé publique indiquée par
  Signed-By. Sans ça, n'importe qui capable de s'intercaler entre toi
  et le dépôt pourrait te faire installer un paquet piégé... qui
  s'exécute en root.

À RETENIR

  - « apt update » met à jour la liste, « apt upgrade » met à jour les
    paquets installés, « apt install » installe. Trois choses différentes.
  - Les dépôts : /etc/apt/sources.list.d/*.sources (format deb822,
    le format moderne) ou *.list (format une ligne, l'ancien).
  - Une clé par dépôt, référencée par Signed-By : la clé d'un dépôt
    tiers ne doit pas pouvoir signer les paquets de Debian.
  - « trusted=yes » désactive la vérification : à ne jamais utiliser
    en production.
  - « apt policy <paquet> » : quelles versions sont disponibles, et
    depuis quel dépôt.
