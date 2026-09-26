Commence par observer avant de toucher à quoi que ce soit :

    ls -ld /srv/compta              # le dossier lui-même
    ls -l /srv/compta               # ce qu'il contient (en root : sudo)
    id alice ; id bob ; id mallory  # à quels groupes appartient chacun ?

Qui est propriétaire du dossier ? Quel est son groupe ?
---
Sur un dossier, les droits ne veulent pas dire la même chose que sur un fichier :

    r  lister les noms des fichiers
    w  créer, renommer, supprimer des fichiers dedans
    x  « traverser » le dossier (y entrer, accéder aux fichiers)

L'idée : faire en sorte que le dossier et le fichier appartiennent au
groupe compta, donner les bons droits à ce groupe, et vérifier que
toute l'équipe fait bien partie du groupe.
---
Les commandes utiles :

    chgrp        changer le groupe d'un fichier ou dossier (-R : récursif)
    chmod        changer les droits (ex : chmod 770, chmod g+rw)
    usermod -aG  ajouter un utilisateur à un groupe

Attention : « usermod -G » sans le « -a » REMPLACE tous les groupes
de l'utilisateur au lieu d'en ajouter un !
