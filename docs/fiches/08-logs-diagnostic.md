# 08 · Logs et diagnostic

!!! note "Fiche à rédiger"
    Cette fiche s'écrit **après** avoir fait les labs du module, avec tes
    propres mots. Les questions ci-dessous servent de fil conducteur :
    remplace-les par tes explications au fur et à mesure.

## Où sont les logs ?

- Qu'est-ce que journald ? Que collecte-t-il ?
- Quelle différence entre le journal systemd et les fichiers de
  `/var/log/` ?
- Que sont les priorités (`err`, `warning`, `info`…) ?

## Lire le journal

- Comment filtrer par service, priorité, période, démarrage, motif ?
- Comment suivre les logs en direct ?
- Comment voir les logs du démarrage précédent ? Pourquoi est-ce parfois
  impossible ?

## Garder les logs… sans remplir le disque

- Que font `Storage=` et `SystemMaxUse=` dans la configuration de journald ?
- Dans quel ordre journald lit-il ses fichiers de configuration ? Quelle
  valeur l'emporte ? (Et pour sshd ?)
- Comment fonctionne logrotate ? Que signifient `daily`, `rotate`,
  `compress`, `delaycompress`, `copytruncate`, `postrotate` ?
- Pourquoi un programme qui garde son log ouvert pose-t-il problème lors
  d'une rotation ?

## Une méthode de diagnostic

- Par quoi commences-tu face à une panne ? Écris ta propre checklist
  (logs, état des services, disque, réseau…).

## Labs du module

| Lab | Niveau | Sujet |
|-----|--------|-------|
| `logs-01` | débutant | L'erreur noyée dans le bruit (`journalctl -u -p err`) |
| `logs-02` | intermédiaire | Le log qui ne s'arrête jamais (logrotate, `copytruncate`) |
| `logs-03` | intermédiaire | Les logs qui s'évaporent (journal persistant, `SystemMaxUse`) |
