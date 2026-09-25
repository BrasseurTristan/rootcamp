# 02 · Utilisateurs et permissions

!!! note "Fiche à rédiger"
    Cette fiche s'écrit **après** avoir fait les labs du module, avec tes
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

## Dossiers partagés

- Pourquoi un fichier créé par alice n'est-il pas modifiable par bob, même
  dans un dossier du groupe ? Que fait l'umask ?
- Que change le bit setgid posé sur un dossier ?
- Qu'est-ce qu'une ACL, et une ACL *par défaut* ? Pourquoi est-ce plus fiable
  que de changer l'umask ?

## sudo et le moindre privilège

- Comment se lit une ligne de `/etc/sudoers` ?
- Pourquoi toujours passer par `visudo` ?
- Pourquoi autoriser une seule commande plutôt que `ALL` ? Quelles commandes
  sont dangereuses à autoriser ?

## Les pièges

- Pourquoi `chmod 777` n'est jamais une bonne solution ?
- Pourquoi éviter `chmod -R` avec des droits numériques ?

## Labs du module

| Lab | Niveau | Sujet |
|-----|--------|-------|
| `permissions-01` | débutant | Le dossier partagé de la compta |
| `permissions-02` | intermédiaire | Les fichiers verrouillés de la compta (setgid, ACL) |
| `permissions-03` | intermédiaire | Le compte de déploiement tout-puissant (sudo) |
