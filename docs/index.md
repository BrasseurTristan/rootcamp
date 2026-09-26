# rootcamp

**Apprendre Linux en réparant des serveurs cassés.**

Suivre un tuto pas à pas, ça marche… jusqu'au jour où quelque chose ne se passe
pas comme prévu. rootcamp prend le problème à l'envers : on te donne une machine
Debian **volontairement cassée**, un ticket à résoudre, et c'est à toi de
comprendre ce qui ne va pas.

## Comment ça marche

Chaque module du parcours associe deux choses :

- **une fiche** (sur ce site) qui explique le *pourquoi* : comment le système
  fonctionne vraiment, ce que fait chaque commande, les pièges classiques ;
- **des labs** dans une VM Debian jetable, pilotés par l'outil `rootcamp`.

```console
$ rootcamp start permissions-01   # prépare le lab… et casse la machine
$ rootcamp hint                   # un indice si tu bloques
$ rootcamp check                  # vérifie ta solution
```

Quand tu réussis, un **débrief** t'explique ce qui était cassé et pourquoi ta
solution fonctionne.

!!! warning "Uniquement dans une VM jetable"
    Les labs créent des utilisateurs, modifient des droits, arrêtent des
    services… N'installe jamais rootcamp sur une vraie machine.

[Démarrer :material-arrow-right:](demarrer.md){ .md-button .md-button--primary }
[Voir le parcours](parcours.md){ .md-button }
