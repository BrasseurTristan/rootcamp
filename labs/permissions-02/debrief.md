CE QUI ÉTAIT CASSÉ

  Chaque fichier créé prenait le groupe principal de son auteur
  (le groupe « alice » pour alice) et les droits 644 à cause de
  l'umask 022. Résultat : lisible par le groupe, jamais modifiable.

UNE SOLUTION

    # les fichiers existants
    sudo chgrp -R compta /srv/compta
    sudo chmod g+w /srv/compta/relances.txt /srv/compta/factures/*
    sudo chmod g+rwxs /srv/compta/factures

    # les futurs fichiers
    sudo chmod g+s /srv/compta
    sudo setfacl -d -m g::rwx /srv/compta
    sudo setfacl -d -m g::rwx /srv/compta/factures

POURQUOI ÇA MARCHE

  Le bit setgid (le « s » dans drwxrws---) sur un dossier : tout ce
  qui est créé dedans hérite du GROUPE du dossier au lieu du groupe
  principal de l'auteur. Les nouveaux sous-dossiers héritent aussi du
  bit setgid, donc ça se propage.

  Une ACL par défaut (setfacl -d) est un modèle de droits attaché au
  dossier : chaque nouveau fichier la reçoit à sa création, et elle
  REMPLACE l'umask. Avec « g::rwx », le groupe obtient rw sur les
  fichiers et rwx sur les dossiers, quel que soit l'umask du programme.

  Vérifie avec getfacl : tu verras les lignes « default: ».
  Dans ls -l, un « + » après les droits signale qu'il y a des ACL.

À RETENIR

  - Groupe hérité : bit setgid. Droits hérités : ACL par défaut.
    Les deux vont ensemble pour un dossier partagé.
  - Changer l'umask (dans .bashrc, /etc/login.defs...) ne marche que
    pour les sessions concernées : pas pour un service, un cron, un
    transfert SFTP... C'est pour ça qu'on attache la règle au dossier.
  - Les réglages d'un dossier ne touchent que les fichiers créés
    APRÈS : pense toujours à corriger l'existant.
