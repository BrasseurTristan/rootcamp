CE QUI ÉTAIT CASSÉ

  deploy était membre du groupe sudo. Dans /etc/sudoers, la ligne

      %sudo ALL=(ALL:ALL) ALL

  donne aux membres de ce groupe le droit de TOUT lancer en root,
  avec leur mot de passe. Un mot de passe volé = serveur compromis.

UNE SOLUTION

    sudo gpasswd -d deploy sudo
    sudo visudo -f /etc/sudoers.d/deploy

  avec dans le fichier :

    deploy ALL=(root) NOPASSWD: /usr/local/bin/deployer-appli

POURQUOI ÇA MARCHE

  deploy        la règle concerne cet utilisateur
  ALL=          sur n'importe quelle machine (utile pour un sudoers
                partagé entre plusieurs serveurs)
  (root)        il peut agir en tant que root, et seulement root
  NOPASSWD:     sans taper de mot de passe
  /usr/local/…  cette commande, et elle seule, avec son chemin complet

  C'est le principe du MOINDRE PRIVILÈGE : chaque compte a exactement
  les droits dont il a besoin, rien de plus.

À RETENIR

  - Toujours visudo (ou visudo -f pour un fichier de sudoers.d) : une
    faute de syntaxe peut bloquer sudo pour tout le monde.
  - Les fichiers de /etc/sudoers.d/ dont le nom contient un « . » ou
    finit par « ~ » sont ignorés sans le moindre message.
  - « sudo -l » montre ce qu'on a le droit de faire : premier réflexe
    pour diagnostiquer un problème de sudo.
  - Méfie-toi des commandes autorisées qui permettent d'en lancer
    d'autres : autoriser « vim », « less » ou « find » en root, c'est
    donner un shell root (ex. « :!bash » dans vim). Le script autorisé
    ne doit pas non plus être modifiable par deploy !
  - Écrire « deployer-appli "" » dans la règle interdit de lui passer
    des arguments, si le script n'en a pas besoin.
