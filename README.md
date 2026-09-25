# rootcamp

**Apprendre Linux en réparant des serveurs cassés.**

rootcamp te donne une VM Debian volontairement cassée, un ticket à résoudre, et
c'est à toi de comprendre ce qui ne va pas. Chaque module associe une **fiche**
qui explique le *pourquoi* et des **labs** pour pratiquer.

📖 **Le site des fiches : https://brasseurtristan.github.io/rootcamp/**

```console
$ rootcamp start permissions-01   # prépare le lab… et casse la machine
$ rootcamp hint                   # un indice si tu bloques
$ rootcamp check                  # vérifie ta solution
$ rootcamp debrief                # ce qui était cassé et pourquoi
```

## Le parcours

| # | Module | Labs |
|---|--------|------|
| 01 | Shell et arborescence | `shell-01` à `03` |
| 02 | Utilisateurs et permissions | `permissions-01` à `03` |
| 03 | Processus et systemd | `systemd-01`, `systemd-02`, `processus-01` |
| 04 | Paquets | `paquets-01` à `03` |
| 05 | Stockage | `stockage-01` à `03` |
| 06 | Réseau | `reseau-01` à `04` |
| 07 | SSH | `ssh-01` à `03` |
| 08 | Logs et diagnostic | `logs-01` à `03` |
| 09 | Serveur web | `web-01` à `03` |
| 10 | Projet final | `final-01`, `final-02` |

## Démarrage rapide

Il te faut [Vagrant](https://developer.hashicorp.com/vagrant/install) et un
hyperviseur : **VMware Fusion** sur Mac, **VirtualBox** sur Windows. Le guide
détaillé est sur le [site](https://brasseurtristan.github.io/rootcamp/demarrer/).

```bash
git clone https://github.com/BrasseurTristan/rootcamp.git
cd rootcamp
vagrant up
vagrant ssh
rootcamp list
```

Tu as déjà une Debian 13 jetable ? Installe rootcamp directement dessus :

```bash
curl -fsSL https://raw.githubusercontent.com/BrasseurTristan/rootcamp/main/install.sh | sudo bash
```

> ⚠️ Les labs cassent volontairement la machine : n'installe jamais rootcamp
> sur une vraie machine.

## Organisation du dépôt

```
bin/rootcamp      l'outil en ligne de commande
lib/lab.sh        fonctions partagées par les labs
labs/<lab>/       un dossier par lab (voir CONTRIBUTING.md)
docs/             le site des fiches (MkDocs)
tests/            tests automatiques des labs
install.sh        installation dans une Debian 13
Vagrantfile       la VM prête à l'emploi
```

## Contribuer

Les idées de labs et les corrections sont les bienvenues : voir
[CONTRIBUTING.md](CONTRIBUTING.md).

## Licence

[MIT](LICENSE)
