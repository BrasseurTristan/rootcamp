# 09 · Serveur web

!!! note "Fiche à rédiger"
    Cette fiche s'écrit **après** avoir fait les labs du module, avec tes
    propres mots. Les questions ci-dessous servent de fil conducteur :
    remplace-les par tes explications au fur et à mesure.

## nginx

- Comment est organisée la configuration (`nginx.conf`, `sites-available`,
  `sites-enabled`, blocs `server` et `location`) ?
- Que font les directives `listen`, `server_name`, `root`, `index` ?
- Avec quel utilisateur nginx lit-il les fichiers ? Qu'est-ce que ça
  implique pour les droits ?
- Quelle différence entre `reload` et `restart` ? Pourquoi toujours
  `nginx -t` avant ?

## Les codes HTTP

- Que signifient 200, 301, 403, 404, 500, 502, 504 ?
- Où lire la raison exacte d'une erreur ?

## Reverse proxy

- Qu'est-ce qu'un reverse proxy ? Pourquoi placer nginx devant une
  application ?
- Que fait `proxy_pass` ? Pourquoi transmettre `Host`, `X-Forwarded-For` et
  `X-Forwarded-Proto` ?

## HTTPS

- Qu'apporte TLS (chiffrement, authentification) ?
- Clé privée, CSR, certificat, autorité de certification : qui fait quoi ?
- Pourquoi le nom doit-il être dans le `subjectAltName` ?
- Comment lire un certificat, et voir celui que présente un serveur ?
- Comment rediriger tout le trafic HTTP vers HTTPS ?

## Labs du module

| Lab | Niveau | Sujet |
|-----|--------|-------|
| `web-01` | débutant | Le site interdit (403, droits de www-data, `index`) |
| `web-02` | intermédiaire | La passerelle en panne (502, `proxy_pass`, `X-Forwarded-For`) |
| `web-03` | avancé | Le cadenas manquant (CSR, CA interne, SAN, redirection HTTPS) |
