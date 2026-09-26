CE QUI ÉTAIT CASSÉ

  sshd_config.d/10-migration.conf, lu en premier grâce à l'Include :

    PasswordAuthentication yes
    PermitRootLogin yes

  Plus bas dans sshd_config, « PermitRootLogin prohibit-password »
  donnait une fausse impression de sécurité : sshd garde la première
  valeur lue, cette ligne était ignorée.

UNE SOLUTION

  Remplacer le contenu du vieux fichier (ou le supprimer et mettre les
  réglages dans un nouveau fichier de sshd_config.d/) :

    PasswordAuthentication no
    PermitRootLogin no

  puis :

    sudo sshd -t -f /etc/rootcamp/ssh/srv-web/sshd_config
    sudo systemctl restart ssh-srv-web

POURQUOI ÇA MARCHE

  « sshd -T » affiche la configuration EFFECTIVE, après lecture de tous
  les fichiers : c'est la seule vérité. Sur Debian, le vrai
  /etc/ssh/sshd_config commence aussi par « Include
  /etc/ssh/sshd_config.d/*.conf » : mets tes réglages dans un fichier
  de ce dossier, ils passeront avant ceux du fichier principal.

  PermitRootLogin :
    yes                 root peut se connecter, même par mot de passe
    prohibit-password   root seulement avec une clé
    no                  jamais : on se connecte avec son compte, puis sudo
                        (on sait QUI a fait quoi)

À RETENIR

  - Sur un serveur exposé : PasswordAuthentication no, PermitRootLogin no.
  - sshd -T pour la configuration effective, sshd -t pour valider
    avant de redémarrer.
  - Garde TOUJOURS une session ouverte pendant que tu modifies SSH, et
    teste la connexion dans un deuxième terminal avant de la fermer.
  - Redémarrer sshd ne coupe pas les sessions déjà ouvertes.
  - Pour aller plus loin : fail2ban bloque les adresses qui échouent
    trop souvent.
