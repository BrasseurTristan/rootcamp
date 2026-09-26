# 10 · Projet final

!!! note "Fiche à rédiger"
    Cette fiche est ton **bilan**. Écris-la après les deux labs du module :
    elle te servira de modèle la prochaine fois que tu mettras un service en
    production, ou que tu seras d'astreinte.

## Ma checklist de mise en production

Reprends le cahier des charges de `final-01` et transforme-le en checklist
réutilisable, dans l'ordre où tu fais les choses :

- [ ] compte de service…
- [ ] …

Pour chaque étape, note la commande qui permet de **vérifier** qu'elle est
faite.

## Ma méthode de diagnostic

Après `final-02`, écris ta méthode face à une panne inconnue :

1. Constater (quoi, vu d'où ?)
2. …

Pour chaque couche (nom, réseau, pare-feu, serveur web, application, données),
note la commande qui te donne l'information la plus utile.

## Ce que je ferais mieux en vrai

- Qu'est-ce qui aurait permis de détecter les pannes de `final-02` **avant**
  les utilisateurs ? (supervision, alertes sur l'expiration des certificats…)
- Qu'est-ce qui aurait évité la « petite maintenance » ratée ? (revue des
  changements, configuration versionnée, automatisation…)

## Labs du module

| Lab | Niveau | Sujet |
|-----|--------|-------|
| `final-01` | avancé | Mise en production (compte, systemd, HTTPS, reverse proxy, pare-feu) |
| `final-02` | avancé | La nuit de garde (trois pannes tirées au sort parmi six) |
