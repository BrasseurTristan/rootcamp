Commence par vérifier que tu peux te connecter :

    ssh -i ~/.ssh/cle_bdd deploy@10.20.0.2

Une fois connecté sur srv-bdd, l'interface répond-elle ?

    curl http://127.0.0.1:8080

Depuis ton serveur, en revanche, « curl http://10.20.0.2:8080 » échoue.
---
Le fichier ~/.ssh/config définit des raccourcis :

    Host bdd
        HostName 10.20.0.2
        User deploy
        IdentityFile ~/.ssh/cle_bdd

Un tunnel « local » (-L) fait écouter ssh sur un port de TA machine,
et transporte chaque connexion jusqu'au serveur distant, qui la
relaie vers une destination vue DEPUIS LUI :

    ssh -L <port local>:<destination>:<port destination> <serveur>
---
    ssh -f -N -L 9000:127.0.0.1:8080 bdd

  -L 9000:127.0.0.1:8080  le port 9000 d'ici mène à 127.0.0.1:8080
                          vu depuis srv-bdd
  -N                      pas de commande à distance, juste le tunnel
  -f                      passer en arrière-plan

Puis :

    curl http://127.0.0.1:9000
