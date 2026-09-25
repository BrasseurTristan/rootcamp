LES PANNES POSSIBLES (trois étaient actives cette nuit)

  dns         /etc/hosts envoyait carnet.interne vers 10.99.0.14
              → getent hosts, puis corriger /etc/hosts
  pare-feu    le port 443 avait disparu de /etc/nftables.conf
              → timeout depuis le poste d'Alice ; nft list ruleset
  certificat  nginx pointait vers une clé qui ne correspondait pas au
              certificat : nginx -t échouait, nginx ne redémarrait plus
              → « key values mismatch » dans nginx -t
  proxy       proxy_pass vers le port 5050 au lieu de 5000
              → 502, « connection refused » dans le journal de nginx
  service     ExecStart vers /opt/carnet/carnet-v2.py (inexistant)
              → status=203/EXEC dans systemctl status carnet (et, après
                trop d'échecs, « start-limit-hit » : systemctl reset-failed)
  donnees     /var/lib/carnet appartenait à root (700)
              → 500 à l'enregistrement, PermissionError dans journalctl -u carnet

LA MÉTHODE

  Face à une panne dont on ne connaît pas la cause :

    1. Constater précisément : quel symptôme, vu d'où ? (curl -v)
    2. Suivre le chemin de la requête, couche par couche :
       nom → réseau → pare-feu → serveur web → application → données
    3. À chaque couche, LIRE LES JOURNAUX avant de toucher à quoi que ce soit.
    4. Corriger une chose à la fois, et vérifier après chaque correction.
    5. Ne pas s'arrêter au premier problème trouvé : il y en a souvent
       plusieurs (et le premier en cache d'autres).
    6. Après coup : noter ce qui s'est passé et comment l'éviter
       (supervision du certificat, revue des changements...).

TU AS TERMINÉ ROOTCAMP

  Tu sais maintenant lire un système Linux, pas juste suivre un tuto.
  Refais ce lab (reset) jusqu'à trouver les pannes en quelques minutes,
  et complète tes fiches : c'est ton aide-mémoire pour la suite.
