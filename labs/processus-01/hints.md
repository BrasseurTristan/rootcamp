Trouve d'abord le coupable :

    top                         (trié par CPU ; q pour quitter)
    ps aux --sort=-%cpu | head

Note son PID, son utilisateur et sa commande. Puis tue-le :

    sudo kill <PID>

Relance top quelques secondes plus tard. Il est revenu, avec un autre
PID ? Quelqu'un le relance...
---
Chaque processus a un PARENT (le processus qui l'a lancé), identifié
par son PPID. Qui est le parent de l'indexeur ?

    ps -o pid,ppid,user,cmd -p <PID>
    pstree -p bob             (l'arbre des processus de bob)
    ps -ef --forest

Et ce parent, qui l'a lancé ? Et qui le relancera au redémarrage ?
Pense aux tâches planifiées de bob.
---
Les commandes utiles :

    sudo kill <PID du parent>        d'abord le parent...
    sudo kill <PID de l'indexeur>    ...puis l'enfant
    sudo pkill -f /opt/outils/...    tuer par ligne de commande
    sudo crontab -l -u bob           voir la crontab de bob
    sudo crontab -e -u bob           la modifier

Si un processus ne meurt pas avec kill (signal TERM), essaie kill -9
(signal KILL) en dernier recours.
