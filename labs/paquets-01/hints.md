Lis attentivement ce que dit apt :

    sudo apt update

Les lignes « Err », « Warning » et « Error » (« W: » et « E: » avec
apt-get) qui parlent du dépôt interne disent exactement ce qui ne va
pas. Puis regarde comment le dépôt est
déclaré :

    ls /etc/apt/sources.list.d/
    cat /etc/apt/sources.list.d/depot-interne.sources
---
Deux problèmes dans la déclaration du dépôt :

  URIs:       le chemin correspond-il au dossier réel du dépôt ?
  Signed-By:  apt vérifie la signature du dépôt avec CETTE clé.
              Le fichier existe-t-il ?

La clé publique est fournie avec le dépôt. L'emplacement conseillé
pour les clés des dépôts tiers est /etc/apt/keyrings/.
---
Les corrections :

    sudo cp /srv/depot-interne/cle-publique.asc /etc/apt/keyrings/depot-interne.asc
    sudo nano /etc/apt/sources.list.d/depot-interne.sources

  URIs: file:/srv/depot-interne
  Signed-By: /etc/apt/keyrings/depot-interne.asc

Puis :

    sudo apt update
    sudo apt install facturation-agent
