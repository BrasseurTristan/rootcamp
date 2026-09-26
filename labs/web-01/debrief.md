CE QUI ÉTAIT CASSÉ

  1. root /home/alice/site-compta : nginx (utilisateur www-data) ne
     pouvait pas traverser /home/alice (droits 750). Journal :
     « open() ... failed (13: Permission denied) ».
  2. index index.html : la page s'appelait accueil.html. Sans fichier
     d'index, nginx refuse de lister le dossier : « directory index of
     ... is forbidden ».

UNE SOLUTION

    sudo mkdir -p /var/www/compta
    sudo cp -r /home/alice/site-compta/. /var/www/compta/
    sudo mv /var/www/compta/accueil.html /var/www/compta/index.html

  et dans /etc/nginx/sites-available/compta :

    root /var/www/compta;

  puis :

    sudo nginx -t && sudo systemctl reload nginx

POURQUOI ÇA MARCHE

  Un serveur web n'a pas de droits particuliers : il accède aux
  fichiers avec son utilisateur (www-data), soumis aux mêmes règles
  rwx que tout le monde. Ranger les sites dans /var/www (lisibles par
  tous, modifiables seulement par les admins) évite d'ouvrir les
  dossiers personnels.

  Le code 403 (Forbidden) veut dire « je ne te le donnerai pas » :
  c'est presque toujours une question de droits ou d'index. Le 404,
  lui, veut dire « je ne trouve pas ».

À RETENIR

  - Le journal d'erreurs de nginx (/var/log/nginx/*error.log) donne
    toujours la raison exacte d'un 403, 404, 502...
  - nginx -t avant chaque reload : une erreur de syntaxe empêcherait
    nginx de redémarrer.
  - « reload » applique la nouvelle configuration sans couper les
    connexions en cours, « restart » arrête tout puis relance.
  - Les sites : /etc/nginx/sites-available/ (tous), sites-enabled/ (liens
    vers ceux qui sont actifs).
