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
module: 02-utilisateurs-permissions   # voir labs/modules.txt
level: débutant        # débutant, intermédiaire ou avancé
duration: 15 min
packages: acl          # facultatif : paquets Debian nécessaires au lab
```

Les paquets de `packages` sont installés par `install.sh` et, s'il en manque,
par `rootcamp start`.

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

**Piège** : les scripts tournent avec `set -o pipefail`. Dans ce mode,
`commande | grep -q motif` peut échouer au hasard : `grep -q` s'arrête à la
première correspondance, et `commande` reçoit un SIGPIPE si elle écrit encore.
Capture d'abord la sortie :

```bash
regles=$(nft list ruleset)
if grep -q 'dport 22' <<<"$regles"; then …
```

### Les bibliothèques de `lib/`

En plus de `lib/lab.sh` (chargé par tous les labs), des bibliothèques
simulent l'environnement d'un vrai serveur. Charge-les dans `setup.sh` et
`check.sh` avec `source "$RC_LIB/<fichier>"` :

| Fichier | Ce qu'il apporte | Utilisé par |
|---------|------------------|-------------|
| `depot.sh` | un dépôt APT interne signé, avec de vrais paquets `.deb` | module 04 |
| `disques.sh` | des disques virtuels (loop) qu'on peut partitionner, formater, mettre en LVM | module 05 |
| `reseau.sh` | des « machines » simulées (netns + veth), de petits services réseau | modules 06, 07, 10 |
| `ssh.sh` | des serveurs SSH « distants » (jamais le SSH de la VM) | module 07 |
| `web.sh` | activer un site nginx, déclarer un nom dans `/etc/hosts` | modules 09, 10 |
| `carnet.sh` | l'application des labs finaux, son déploiement et sa vérification | module 10 |

Formule les descriptions comme l'état attendu (« bob peut lire le fichier ») :
en rouge, elles indiquent quoi corriger sans donner la solution.

### Tests

Chaque lab doit avoir une solution de référence dans
`tests/solutions/<lab>.sh`, et idéalement :

- des mauvaises solutions typiques dans `tests/solutions/<lab>.wrong-<nom>.sh`
  (par exemple un `chmod 777`), que le check doit refuser ;
- d'autres solutions correctes dans `tests/solutions/<lab>.alt-<nom>.sh` (des
  ACL au lieu d'un `chmod`, un drop-in au lieu d'un fichier complet…), que le
  check doit accepter.

La CI vérifie pour chaque lab que :

1. le check échoue juste après le setup ;
2. chaque mauvaise solution est refusée ;
3. la solution de référence et chaque autre solution sont acceptées ;
4. un reset remet bien le lab dans son état cassé.

Pour lancer les tests dans la VM Vagrant :

```bash
sudo bash /opt/rootcamp/tests/run-labs.sh                  # tous les labs
sudo bash /opt/rootcamp/tests/run-labs.sh permissions-02   # un seul lab
```

Ou, comme la CI, dans un conteneur Debian 13 avec systemd :

```bash
docker build -t rootcamp-test -f tests/Dockerfile .
docker run -d --name rootcamp --privileged --cgroupns=host \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw -v /dev:/dev rootcamp-test
docker exec rootcamp bash /opt/rootcamp/tests/run-labs.sh
docker rm -f rootcamp
```

## Écrire ou corriger une fiche

Les fiches sont dans `docs/fiches/`. Pour prévisualiser le site :

```bash
pip install -r requirements-docs.txt
mkdocs serve
```

## Style

- Tout le contenu est en français, en tutoyant.
- Scripts en Bash, vérifiés par [ShellCheck](https://www.shellcheck.net/) 0.11
  (`pip install shellcheck-py==0.11.0.1`).
