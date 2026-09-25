logrotate a un mode « simulation » qui explique ce qu'il ferait, et
signale les erreurs :

    sudo logrotate -d /etc/logrotate.d/facturation-app

Regarde aussi comment sont écrites les autres configurations :

    ls /etc/logrotate.d/
    cat /etc/logrotate.d/apt
---
Deux erreurs de syntaxe dans le fichier : une valeur qui devrait être
un nombre, et un bloc qui n'est pas fermé.

Une fois la syntaxe corrigée, fais une rotation forcée et regarde si
app.log grossit ensuite :

    sudo logrotate -f /etc/logrotate.d/facturation-app
    ls -l /var/log/facturation-app/ ; sleep 3 ; ls -l /var/log/facturation-app/

L'application a ouvert son fichier UNE fois au démarrage. Après la
rotation, elle écrit toujours dans le fichier renommé (app.log.1)...
---
Deux façons de régler le problème du fichier ouvert :

  copytruncate                  logrotate copie le log puis le vide sur
                                place : l'appli continue sans rien voir
                                (on peut perdre quelques lignes)

  postrotate                    après la rotation, prévenir l'appli
      systemctl restart ...     (ici, la redémarrer ; beaucoup d'applis
  endscript                     savent rouvrir leur log sur un signal HUP)
