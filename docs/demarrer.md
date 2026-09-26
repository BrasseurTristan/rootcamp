# Démarrer

rootcamp tourne dans une **VM Debian 13** que tu peux casser sans risque. La
façon la plus simple de l'obtenir est **Vagrant**, un outil qui crée et
configure des VM à partir d'un fichier texte (le `Vagrantfile` du dépôt).

## 1. Installer les outils

=== "Mac"

    Sur Mac (puce Apple ou Intel), on utilise VMware Fusion, gratuit.

    1. Installe [VMware Fusion](https://www.vmware.com/products/desktop-hypervisor/workstation-and-fusion)
       (il faut créer un compte Broadcom pour le télécharger).
    2. Installe Vagrant et son module VMware avec [Homebrew](https://brew.sh) :

        ```bash
        brew tap hashicorp/tap
        brew install hashicorp/tap/hashicorp-vagrant
        brew install --cask vagrant-vmware-utility
        vagrant plugin install vagrant-vmware-desktop
        ```

=== "Windows"

    Sur Windows, le plus simple est VirtualBox. Dans un terminal PowerShell :

    ```powershell
    winget install Oracle.VirtualBox
    winget install Hashicorp.Vagrant
    ```

    Redémarre ensuite ton PC.

    !!! tip "Tu préfères VMware ?"
        VMware Workstation Pro marche aussi : installe-le, puis
        [vagrant-vmware-utility](https://developer.hashicorp.com/vagrant/install/vmware)
        et lance `vagrant plugin install vagrant-vmware-desktop`.

## 2. Créer la VM

```bash
git clone https://github.com/BrasseurTristan/rootcamp.git
cd rootcamp
vagrant up
```

La première fois, Vagrant télécharge l'image Debian : compte quelques minutes.

## 3. Se connecter et lancer un lab

```bash
vagrant ssh
rootcamp list
rootcamp start permissions-01
```

## Au quotidien

| Tu veux…                              | Commande (sur ta machine) |
|---------------------------------------|---------------------------|
| te connecter à la VM                  | `vagrant ssh`             |
| éteindre la VM                        | `vagrant halt`            |
| tout supprimer et repartir de zéro    | `vagrant destroy` puis `vagrant up` |
| récupérer les nouveaux labs           | `git pull`                |

## Sans Vagrant

rootcamp s'installe dans n'importe quelle **Debian 13** : une VM créée à la main
(UTM, Hyper-V, VirtualBox…) ou un petit serveur loué. Une fois connecté dessus :

```bash
curl -fsSL https://raw.githubusercontent.com/BrasseurTristan/rootcamp/main/install.sh | sudo bash
```

!!! tip "Installer Debian toi-même"
    Créer ta VM à partir de l'ISO Debian (partitionnement, choix des paquets,
    premier utilisateur) est un excellent premier exercice pour comprendre ce
    qu'est un serveur.
