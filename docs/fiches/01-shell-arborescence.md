# 01 · Shell et arborescence

!!! note "Fiche à rédiger"
    Cette fiche s'écrit **après** avoir fait les labs du module, avec tes
    propres mots. Les questions ci-dessous servent de fil conducteur :
    remplace-les par tes explications au fur et à mesure.

## L'arborescence

- Pourquoi dit-on que sous Linux « tout est fichier » ?
- À quoi sert chacun de ces dossiers : `/etc`, `/home`, `/srv`, `/var`,
  `/var/log`, `/tmp`, `/usr`, `/usr/local`, `/opt`, `/root` ?
- Quelle différence entre un chemin absolu et un chemin relatif ? Que
  désignent `.`, `..` et `~` ?

## Trouver et lire

- Comment chercher un fichier par nom, par date, par taille avec `find` ?
- Comment chercher un texte dans des fichiers avec `grep` (et `grep -r`) ?
- `cat`, `less`, `head`, `tail`, `tail -f` : quand utiliser lequel ?

## Les pipes

- Que fait `|` exactement ?
- Pourquoi faut-il trier avant `uniq -c` ?
- Comment extraire une colonne avec `awk` ou `cut` ?

## Entrées, sorties, erreurs

- Que sont les descripteurs 0, 1 et 2 ?
- Quelle différence entre `>`, `>>`, `2>`, `2>&1` ? Pourquoi l'ordre de
  `> fichier 2>&1` compte-t-il ?
- Que se passe-t-il quand on redirige vers `/dev/null` ?

## Lancer des commandes

- Qu'est-ce que le `PATH` ? Comment savoir où se trouve une commande
  (`which`, `type`) ?
- Pourquoi un script a-t-il besoin du droit `x` et d'une ligne `#!` ?
- Qu'est-ce qu'un code de retour ? Comment le lire (`$?`) ?
- Pourquoi une commande qui marche dans ton terminal peut-elle échouer
  dans cron ?

## Labs du module

| Lab | Niveau | Sujet |
|-----|--------|-------|
| `shell-01` | débutant | La configuration égarée (FHS, `find`) |
| `shell-02` | débutant | Le rapport d'erreurs (pipes, `awk`, `sort \| uniq -c`) |
| `shell-03` | intermédiaire | La sauvegarde qui ne dit rien (cron, redirections, `PATH`) |
