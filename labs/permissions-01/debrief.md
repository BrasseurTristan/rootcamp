CE QUI ÉTAIT CASSÉ

  1. /srv/compta appartenait à root:root avec les droits 700 (rwx------) :
     seul root pouvait y entrer.
  2. bilan-2025.txt était en 600 (rw-------) : même avec le dossier
     ouvert, seul root pouvait le lire.
  3. bob n'avait jamais été ajouté au groupe compta.

UNE SOLUTION

    sudo chgrp -R compta /srv/compta
    sudo chmod 770 /srv/compta
    sudo chmod 660 /srv/compta/bilan-2025.txt
    sudo usermod -aG compta bob

POURQUOI ÇA MARCHE

  Pour chaque accès, le noyau regarde QUI tu es, dans cet ordre :
  propriétaire ? sinon membre du groupe ? sinon « les autres ».
  Il applique les droits de la PREMIÈRE catégorie qui correspond.

  770 sur le dossier = rwx pour root, rwx pour le groupe compta,
  rien pour les autres. mallory tombe dans « les autres » : bloquée.

  Pour ouvrir un fichier, il faut le droit x sur TOUS les dossiers du
  chemin, puis le droit r ou w sur le fichier lui-même. C'est pour ça
  qu'il fallait corriger le dossier ET le fichier.

À RETENIR

  - Les groupes d'un utilisateur sont lus à la connexion. Si bob était
    déjà connecté, il doit se déconnecter/reconnecter (ou lancer
    « newgrp compta ») pour que son nouveau groupe soit pris en compte.
    C'est LE piège classique.
  - chmod 777 « marche », mais donne tout à tout le monde, y compris à
    un service web compromis. Ne jamais faire ça.
  - Évite chmod -R 770 : les fichiers deviennent exécutables (x),
    ce qui n'a pas de sens pour un .txt.

POUR ALLER PLUS LOIN

  Si alice crée un fichier, il appartiendra au groupe « alice », pas
  « compta », et bob ne pourra pas le modifier. Pour régler ça : le bit
  setgid sur le dossier (chmod g+s) et l'umask. Ce sera le lab suivant !
