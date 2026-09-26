# 07 · SSH

!!! note "Fiche à rédiger"
    Cette fiche s'écrit **après** avoir fait les labs du module, avec tes
    propres mots. Les questions ci-dessous servent de fil conducteur :
    remplace-les par tes explications au fur et à mesure.

## Les clés

- Comment fonctionne l'authentification par clé ? Pourquoi est-elle plus
  sûre qu'un mot de passe ?
- Où vont la clé privée et la clé publique ? Que contient
  `~/.ssh/authorized_keys` ?
- Quels droits pour `~/.ssh`, `authorized_keys` et la clé privée ?
  Que fait `StrictModes` ?
- À quoi servent `ssh-keygen`, `ssh-copy-id` et `ssh-agent` ?
- Que vérifie `~/.ssh/known_hosts` ? Que signifie l'alerte « REMOTE HOST
  IDENTIFICATION HAS CHANGED » ?

## Diagnostiquer

- Que montre `ssh -v` ? Où lire les logs du serveur ?

## Configurer le serveur

- Pourquoi, dans `sshd_config`, la première valeur lue gagne-t-elle ?
  Quel rôle joue la ligne `Include` ?
- Que montrent `sshd -T` et `sshd -t` ?
- Que font `PasswordAuthentication` et `PermitRootLogin` ? Quelles valeurs
  sur un serveur exposé ?
- Comment modifier la configuration SSH d'un serveur distant sans
  s'enfermer dehors ?

## Côté client

- Que peut-on mettre dans `~/.ssh/config` ?
- Qu'est-ce qu'un tunnel `-L` ? `-R` ? Un rebond avec `-J` (ProxyJump) ?

## Labs du module

| Lab | Niveau | Sujet |
|-----|--------|-------|
| `ssh-01` | débutant | La clé refusée (droits, `StrictModes`, `ssh -v`) |
| `ssh-02` | intermédiaire | Le serveur SSH trop accueillant (durcissement, première valeur lue) |
| `ssh-03` | avancé | L'interface d'administration cachée (`~/.ssh/config`, tunnel `-L`) |
