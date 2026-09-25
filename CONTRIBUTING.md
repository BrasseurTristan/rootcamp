# Contribuer à rootcamp

## Créer un lab

Un lab, c'est une panne réaliste à diagnostiquer et réparer. Chaque lab vit
dans son propre dossier `labs/<module>-<numéro>/` :

```
labs/permissions-01/
├── lab.yaml      titre, module, niveau, durée
├── mission.md    l'énoncé : le « ticket » à résoudre et l'objectif
├── setup.sh      prépare la machine… et la casse
├── check.sh      vérifie que la panne est réparée
├── hints.md      les indices, du plus vague au plus précis
└── debrief.md    ce qui était cassé, une solution, et surtout pourquoi
```

Le plus simple est de copier `labs/permissions-01/` et de l'adapter.

### lab.yaml

Format plat `clé: valeur`, sans imbrication :

```yaml
title: Le dossier partagé de la compta
module: 02-utilisateurs-permissions
level: débutant        # débutant, intermédiaire ou avancé
duration: 15 min
```

### mission.md, hints.md, debrief.md

Ces fichiers sont affichés **tels quels dans le terminal** : écris-les en texte
lisible, sans syntaxe Markdown compliquée (pas de tableaux, pas de liens).

- **mission.md** : un contexte réaliste (un ticket, un message d'un collègue),
  puis un objectif précis et vérifiable. Ne donne pas la solution.
- **hints.md** : sépare les indices par une ligne `---`. Le premier aide à
  *observer*, le dernier peut citer les commandes utiles.
- **debrief.md** : ce qui était cassé, une solution, **pourquoi elle marche**,
  et les pièges à retenir. C'est la partie la plus importante du lab.

### setup.sh

Lancé en root par `rootcamp start` et `rootcamp reset`. Il doit :

- **être rejouable** : le lancer deux fois de suite donne le même état cassé ;
- utiliser `rc_user` et `rc_group` (de `lib/lab.sh`) pour créer utilisateurs et
  groupes : ils sont recréés à neuf à chaque reset, et rootcamp refuse de
  toucher à un compte qu'il n'a pas créé.

La variable `RC_USER` contient le nom de la personne qui fait le lab.

### check.sh

Lancé en root par `rootcamp check`. Il vérifie **le résultat, pas la méthode** :
teste ce que les utilisateurs peuvent faire (avec `as_user`) plutôt que la
valeur exacte d'un `chmod`. Toute solution correcte doit passer, y compris une
à laquelle tu n'avais pas pensé (des ACL par exemple).

Fonctions disponibles (voir `lib/lab.sh`) :

| Fonction | Rôle |
|----------|------|
| `expect_ok "description" cmd…` | la commande doit réussir |
| `expect_fail "description" cmd…` | la commande doit échouer |
| `ok "message"` / `ko "message"` | afficher un point réussi / raté |
| `as_user <utilisateur> cmd…` | lancer une commande avec les droits de quelqu'un |
| `rc_die "message"` | arrêter la vérification (état incohérent) |
| `rc_result` | à appeler à la fin : code de sortie selon les résultats |

Formule les descriptions comme l'état attendu (« bob peut lire le fichier ») :
en rouge, elles indiquent quoi corriger sans donner la solution.

### Tests

Chaque lab doit avoir une solution de référence dans
`tests/solutions/<lab>.sh`, et idéalement des mauvaises solutions typiques dans
`tests/solutions/<lab>.wrong-<nom>.sh` (par exemple un `chmod 777`).

La CI vérifie pour chaque lab que :

1. le check échoue juste après le setup ;
2. chaque mauvaise solution est refusée ;
3. la solution de référence est acceptée ;
4. un reset remet bien le lab dans son état cassé.

Pour lancer les tests en local, dans une Debian 13 jetable (la VM Vagrant par
exemple) :

```bash
sudo bash /opt/rootcamp/tests/run-labs.sh
```

> Les tests de la CI tournent dans un conteneur Docker : un lab qui a besoin de
> systemd, de disques ou du réseau devra être testé dans une VM.

## Écrire ou corriger une fiche

Les fiches sont dans `docs/fiches/`. Pour prévisualiser le site :

```bash
pip install -r requirements-docs.txt
mkdocs serve
```

## Style

- Tout le contenu est en français, en tutoyant.
- Scripts en Bash, vérifiés par [ShellCheck](https://www.shellcheck.net/).
