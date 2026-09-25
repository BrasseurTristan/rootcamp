Commence par regarder le journal, sans tout afficher :

    head /var/log/facturation/acces.log
    wc -l /var/log/facturation/acces.log

Le principe des pipes : la sortie d'une commande devient l'entrée de
la suivante. On construit la commande petit à petit, en regardant le
résultat à chaque étape (ajoute « | head » pour ne pas être noyé).
---
Les étapes :

  1. garder seulement les lignes dont le CODE HTTP est 500
  2. n'en garder que l'adresse IP
  3. compter combien de fois chaque IP apparaît
  4. trier du plus grand au plus petit nombre
  5. garder les 3 premières

Attention à l'étape 1 : « grep 500 » garde aussi les lignes où 500
apparaît ailleurs... la taille, par exemple !
---
Les outils :

    awk '$9 == 500'          lignes dont le 9e champ vaut 500
    awk '{print $1}'         afficher le 1er champ
    sort | uniq -c           compter les lignes identiques (il faut trier avant !)
    sort -rn                 trier par nombre, du plus grand au plus petit
    head -3                  les 3 premières lignes
    > fichier                écrire le résultat dans un fichier
