Lance le test, puis regarde quelle adresse le serveur associe au nom :

    test-bdd
    getent hosts db.interne
    ping -c 2 db.interne

Et le nouveau serveur, répond-il si on l'appelle par son adresse ?

    nc -z -v 10.20.0.2 5432
---
Pour transformer un nom en adresse, Linux suit l'ordre défini dans
/etc/nsswitch.conf (ligne « hosts: »). Regarde-la :

    grep hosts /etc/nsswitch.conf

« files » veut dire : d'abord le fichier /etc/hosts, et seulement
ensuite le DNS. Si /etc/hosts contient le nom, le DNS n'est même pas
consulté !
---
    grep db.interne /etc/hosts
    sudo nano /etc/hosts

Corrige la vieille ligne de db.interne avec l'adresse du nouveau
serveur (10.20.0.2). La supprimer ne suffirait pas ici : le DNS du lab
ne connaît pas db.interne. Attention à ne pas toucher aux autres
lignes, notamment celle de localhost.
