CE QUI ÉTAIT CASSÉ

  Côté client :  ~/.ssh/cle_deploy en 644 → ssh ignore la clé
                 (« UNPROTECTED PRIVATE KEY FILE ») et passe au mot de passe.
  Côté serveur : /home/deploy/.ssh en 777 et authorized_keys appartenant
                 à root en 666 → sshd refuse de faire confiance à ce
                 fichier (« bad ownership or modes »).

UNE SOLUTION

    chmod 600 ~/.ssh/cle_deploy
    sudo chown -R deploy:deploy /home/deploy/.ssh
    sudo chmod 700 /home/deploy/.ssh
    sudo chmod 600 /home/deploy/.ssh/authorized_keys

POURQUOI ÇA MARCHE

  L'authentification par clé : tu gardes la clé PRIVÉE, le serveur
  connaît la clé PUBLIQUE (dans ~/.ssh/authorized_keys). Le serveur
  t'envoie un défi que seule la clé privée peut signer. Rien de secret
  ne circule, contrairement à un mot de passe.

  Si n'importe qui peut modifier authorized_keys, n'importe qui peut y
  ajouter SA clé et se connecter à ta place : sshd refuse donc ces
  fichiers (StrictModes). De même, une clé privée lisible par d'autres
  n'est plus privée : ssh refuse de s'en servir.

À RETENIR

  - ssh -v (ou -vvv) côté client, journalctl côté serveur : les deux
    moitiés du diagnostic.
  - Droits attendus : ~/.ssh en 700, authorized_keys en 600, clé
    privée en 600, le tout appartenant à l'utilisateur.
  - Désactiver StrictModes pour « faire marcher » est une faille, pas
    une solution.
  - ssh-copy-id installe ta clé publique sur un serveur avec les bons
    droits : utilise-le plutôt que de copier à la main.
