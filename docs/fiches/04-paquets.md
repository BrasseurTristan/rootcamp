# 04 · Paquets

!!! note "Fiche à rédiger"
    Cette fiche s'écrit **après** avoir fait les labs du module, avec tes
    propres mots. Les questions ci-dessous servent de fil conducteur :
    remplace-les par tes explications au fur et à mesure.

## Qu'est-ce qu'un paquet ?

- Que contient un fichier `.deb` ? (des fichiers, des métadonnées, des
  scripts…)
- Quelle différence entre `dpkg` et `apt` ?
- Où dpkg garde-t-il la liste de ce qui est installé ?

## Les dépôts

- Qu'est-ce qu'un dépôt ? Où sont-ils déclarés
  (`/etc/apt/sources.list.d/`) ? Quelle différence entre le format
  `.sources` (deb822) et `.list` ?
- Quelle différence entre `apt update`, `apt upgrade` et `apt install` ?
- Pourquoi les dépôts sont-ils signés ? À quoi sert `Signed-By` ?
  Pourquoi `trusted=yes` est-il dangereux ?

## Enquêter

- Comment savoir quel paquet a installé un fichier ? Quels fichiers un
  paquet a installés ?
- Comment vérifier que les fichiers d'un paquet n'ont pas été modifiés ?
- Que montre `apt policy` ? Comment apt choisit-il la version à installer
  (priorités, candidat) ?

## Contrôler les versions

- Qu'est-ce qu'un « hold » ? Un épinglage (pinning) ?
- Pourquoi un blocage de version doit-il toujours être documenté ?
- Que fait `unattended-upgrades` ?

## Labs du module

| Lab | Niveau | Sujet |
|-----|--------|-------|
| `paquets-01` | intermédiaire | Le dépôt interne introuvable (sources, `Signed-By`, `apt update`) |
| `paquets-02` | débutant | La commande disparue (`dpkg -S`, `dpkg --verify`, `--reinstall`) |
| `paquets-03` | avancé | La mise à jour qui ne vient jamais (hold, pinning, `apt policy`) |
