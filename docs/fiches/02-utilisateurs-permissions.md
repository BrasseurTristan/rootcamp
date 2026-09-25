# 02 · Utilisateurs et permissions

!!! note "Fiche à rédiger"
    Cette fiche s'écrit **après** avoir fait le lab `permissions-01`, avec tes
    propres mots. Les questions ci-dessous servent de fil conducteur :
    remplace-les par tes explications au fur et à mesure.

## Qui est qui ?

- Qu'est-ce qu'un utilisateur pour le noyau ? (indice : UID)
- Où sont stockés les utilisateurs et les groupes ? Que contiennent
  `/etc/passwd`, `/etc/group` et `/etc/shadow` ?
- Quelle différence entre le groupe principal et les groupes secondaires ?

## Lire les droits

- Que signifie chaque caractère de `-rw-r-----` ou `drwxrwx---` ?
- Comment passer de `rwxr-x---` à `750`, et inversement ?
- Dans quel ordre le noyau vérifie-t-il propriétaire, groupe et autres ?

## Fichiers et dossiers, ce n'est pas pareil

- Que permettent `r`, `w` et `x` sur un **dossier** ?
- Pourquoi faut-il le droit `x` sur tous les dossiers d'un chemin ?

## Changer les droits

- `chmod`, `chown`, `chgrp` : à quoi sert chacun ?
- Pourquoi `usermod -G` sans `-a` est-il dangereux ?
- Pourquoi un utilisateur doit-il se reconnecter après avoir été ajouté à un
  groupe ?

## Les pièges

- Pourquoi `chmod 777` n'est jamais une bonne solution ?
- Pourquoi éviter `chmod -R` avec des droits numériques ?

## Labs du module

| Lab | Niveau | Sujet |
|-----|--------|-------|
| `permissions-01` | débutant | Le dossier partagé de la compta |
