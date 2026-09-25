CE QU'IL FALLAIT FAIRE

  Dans ~/.ssh/config :

    Host bdd
        HostName 10.20.0.2
        User deploy
        IdentityFile ~/.ssh/cle_bdd

  Puis :

    ssh -f -N -L 9000:127.0.0.1:8080 bdd
    curl -s http://127.0.0.1:9000 | grep -o 'Jeton.*'

POURQUOI ÇA MARCHE

  Le tunnel :

    ton curl → 127.0.0.1:9000 (ssh local) ══ SSH chiffré ══► sshd de srv-bdd
                                                               → 127.0.0.1:8080

  Pour srv-bdd, la connexion à l'interface vient de lui-même
  (127.0.0.1) : elle est acceptée. Et tout le trajet sur le réseau
  passe dans la connexion SSH, chiffrée.

  C'est un grand classique pour atteindre une base de données, une
  interface d'admin ou un service interne sans l'exposer sur le réseau.

À RETENIR

  - ~/.ssh/config : Host, HostName, User, Port, IdentityFile... Plus
    besoin de retenir les options. « ssh -G <alias> » montre la
    configuration obtenue.
  - LocalForward dans ~/.ssh/config ouvre le tunnel à chaque connexion.
  - -L (local) : un port d'ici mène là-bas. -R (remote) : un port
    de là-bas mène ici. -D : proxy SOCKS.
  - ProxyJump (ssh -J) : rebondir par un serveur intermédiaire
    (« bastion ») pour atteindre des machines non exposées.
  - Côté serveur, AllowTcpForwarding permet d'interdire les tunnels.
