CE QUI ÉTAIT CASSÉ

  Dans /etc/nftables.conf, la chaîne d'entrée (policy drop) :
    - n'autorisait pas le port 8080 : les paquets d'Alice étaient jetés
      en silence, d'où l'attente puis l'erreur (et pas un refus immédiat) ;
    - autorisait le port 3306 depuis n'importe où.

UNE SOLUTION

  Dans /etc/nftables.conf :

      tcp dport 22 accept        # SSH (administration)
      tcp dport 8080 accept      # intranet

  puis :

      sudo nft -c -f /etc/nftables.conf && sudo systemctl restart nftables

POURQUOI ÇA MARCHE

  nftables range ses règles dans des TABLES et des CHAÎNES. La chaîne
  « entree » est accrochée au point « input » du noyau : elle voit
  tous les paquets destinés au serveur. Les règles sont lues dans
  l'ordre, la première qui correspond décide ; sinon, c'est la policy.

    iif lo accept                          tout ce qui vient du serveur
                                           lui-même (la base reste utile !)
    ct state established,related accept    les réponses aux connexions
                                           déjà acceptées
    tcp dport 8080 accept                  les nouvelles connexions à 8080

  « policy drop » + une liste d'exceptions : c'est l'approche par
  LISTE BLANCHE. Un nouveau service n'est pas exposé par accident.

À RETENIR

  - nft list ruleset : les règles actives. /etc/nftables.conf : celles
    chargées au démarrage par le service nftables. Les deux peuvent
    différer si on modifie à chaud avec « nft add rule » !
  - drop = jeter en silence (l'autre attend : timeout) ;
    reject = refuser poliment (l'autre reçoit une erreur tout de suite).
  - Avant de toucher au pare-feu d'un serveur distant, garde une
    session SSH ouverte, et vérifie que la règle SSH est toujours là.
  - Mieux encore : que la base n'écoute que sur 127.0.0.1. Pare-feu ET
    bonne configuration du service, c'est la défense en profondeur.
