# 03 · Processus et systemd

!!! note "Fiche à rédiger"
    Cette fiche s'écrit **après** avoir fait les labs du module, avec tes
    propres mots. Les questions ci-dessous servent de fil conducteur :
    remplace-les par tes explications au fur et à mesure.

## Les processus

- Qu'est-ce qu'un processus ? Que sont le PID et le PPID ?
- Que se passe-t-il pour les enfants quand un processus parent meurt ?
- Comment lire `ps aux`, `ps -ef --forest`, `top`, `pstree` ?
- Qu'est-ce qu'un signal ? Quelle différence entre `TERM`, `KILL` et `HUP` ?
  Pourquoi essayer `TERM` avant `KILL` ?

## systemd

- Pourquoi systemd a-t-il le PID 1 ? Quel est son rôle ?
- Qu'est-ce qu'une unité ? Que contiennent les sections `[Unit]`,
  `[Service]` et `[Install]` ?
- Quelle différence entre `start` et `enable` ? Entre `stop` et `disable` ?
- Où sont rangées les unités ? Pourquoi ne pas modifier celles de
  `/usr/lib/systemd/system/` ?
- Qu'est-ce qu'un fichier de surcharge (drop-in) ? Quand utiliser
  `systemctl edit` plutôt que `systemctl edit --full` ?
- Pourquoi faut-il parfois lancer `systemctl daemon-reload` ?

## Diagnostiquer un service

- Que montre `systemctl status` ? Comment lire les codes comme
  `status=203/EXEC` ou `status=217/USER` ?
- Comment consulter les logs d'un service avec `journalctl -u` ?
  (`-f`, `-b`, `--since`…)
- Que fait `Restart=on-failure` ? Pourquoi un redémarrage automatique ne
  remplace-t-il pas la correction de la cause ?

## Ce qui démarre tout seul

- Comment lister ce qui démarre au boot (services activés, crontabs,
  `/etc/cron.d`) ?

## Labs du module

| Lab | Niveau | Sujet |
|-----|--------|-------|
| `systemd-01` | débutant | Le service qui refuse de démarrer (unité, `status`, `journalctl`, `enable`) |
| `systemd-02` | intermédiaire | Le service qui ne se relève pas (`Restart=`, drop-in) |
| `processus-01` | intermédiaire | Le processus qui revient toujours (PPID, signaux, crontab) |
