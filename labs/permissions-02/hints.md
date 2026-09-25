Observe qui possède quoi, et avec quels droits :

    ls -la /srv/compta /srv/compta/factures
    umask          # le masque appliqué à la création des fichiers

À quel groupe appartient relances.txt ? Pourquoi celui-là ?
---
Deux problèmes distincts :

  1. Le GROUPE : un fichier prend le groupe principal de son créateur.
     Il existe un bit spécial qui, posé sur un dossier, fait hériter
     aux nouveaux fichiers le groupe du dossier. Cherche « setgid »
     dans « man chmod ».

  2. Les DROITS : avec l'umask 022, un nouveau fichier est en 644, donc
     pas modifiable par le groupe. Il faut un mécanisme attaché au
     DOSSIER, qui s'impose à tous les programmes : les ACL par défaut.
---
Les commandes utiles :

    chmod g+s <dossier>                    le bit setgid
    setfacl -d -m g::rwx <dossier>         ACL par défaut : droits du groupe
    getfacl <dossier>                      voir les ACL

N'oublie pas les fichiers et dossiers qui existent déjà : les réglages
du dossier ne s'appliquent qu'aux NOUVEAUX fichiers.
