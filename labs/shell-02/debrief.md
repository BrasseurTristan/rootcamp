LA RÉPONSE

    198.51.100.23   57 erreurs 500
    203.0.113.8     41
    192.0.2.77      33

UNE SOLUTION

    awk '$9 == 500 {print $1}' /var/log/facturation/acces.log \
      | sort | uniq -c | sort -rn | head -3 | awk '{print $2}' \
      > ~/rapport-erreurs.txt

POURQUOI ÇA MARCHE

  Chaque commande fait UNE chose, et le pipe « | » les enchaîne :

    awk '$9 == 500 {print $1}'  filtre sur le code HTTP (9e champ,
                                les champs sont séparés par des espaces)
                                et n'affiche que l'IP
    sort                        regroupe les IP identiques
    uniq -c                     compte les lignes identiques ADJACENTES
                                (d'où le sort juste avant)
    sort -rn                    trie numériquement (-n), à l'envers (-r)
    head -3                     garde les 3 premières lignes
    awk '{print $2}'            garde la 2e colonne (l'IP) de « 57 1.2.3.4 »
    > ~/rapport-erreurs.txt     envoie le résultat dans un fichier

LE PIÈGE

  « grep 500 » ou « grep ' 500' » attrape aussi les réponses de 500
  octets : 10.0.4.12, qui a un trafic énorme mais presque aucune
  erreur, arrive alors en tête. Filtrer sur le bon CHAMP (avec awk)
  plutôt que sur du texte n'importe où dans la ligne évite ce genre de
  faux positifs.

À RETENIR

  - « sort | uniq -c | sort -rn | head » : LA recette pour trouver les
    éléments les plus fréquents. Tu t'en serviras toute ta carrière.
  - Construis tes pipes étape par étape, en vérifiant le résultat de
    chaque morceau avec « | head ».
  - « > » écrase le fichier, « >> » ajoute à la fin.
  - Autres outils à connaître : cut (découper selon un séparateur),
    wc -l (compter les lignes), grep -c (compter les correspondances).
