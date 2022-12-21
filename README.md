# speedcubingfrance.org

Ce dépôt contient les sources du site [speedcubingfrance.org](http://www.speedcubingfrance.org).

# Fonctionnalités

## Pour tous

  - Calendrier des compétitions officielles, en préparation, événements AFS.
  - Export du calendrier au format iCal, pour l'ajouter comme calendrier externe à votre agenda (`/competitions.ics`).
  - Prochaines compétitions en France

## Pour les membres et compétiteurs

  - (TODO) Liste de ressources externes
  - Liste des cotisations
  - Notification 2 jours avant que l'adhésion n'expire

## Pour les organisateurs (et Délégués WCA)

  - Administration des compétitions pour afficher les membres exemptés de frais d'inscription, ou vérifier les nouveaux compétiteurs

## Pour les Délégués et l'administration de l'AFS

  - Gestion du matériel et calendrier prévisionnel
  - Import des cotisations depuis HelloAsso

## Pour l'équipe communication et l'administration de l'AFS

  - Calendrier des événements
  - Articles et tags
  - Gestion des compétitions internationales à afficher en page d'accueil (CdF, Euro, WC)


# Dépendances et installation

Cette section et les suivantes sont à destination des personnes souhaitant contribuer au **développement** du site de l'AFS.

Le site est basé sur Rails (et nécessite donc Ruby), et est déployé sur un VPS.
La base de donnée utilisée est PostgreSQL, qu'il est nécessaire d'installer pour faire tourner le site en local.

## Lancer le site en local

Les dépendances sont gérées via `bundler`, la première chose à faire est donc de lancer `bundle install --path vendor/bundle`.
Le site gère ses dépendances javascript via Yarn, il faut donc les installer également via `bin/yarn`.

Avant de lancer le site, il faut créer et initialiser la base de données.
En local la configuration est disponible dans `config/database.yml`, et le site s'attend à pouvoir utiliser l'utilisateur `speedcubingfrance` avec le mot de passe `fas`.
Il faut donc le créer dans PostgreSQL et lui donner les droits de créer des bases de données.

Une fois fait, la base de données s'initialise via `bin/rails db:setup`.

Le serveur peut se lancer via `bin/rails s`.

### Authentification avec la WCA

L'authentification sur le site se fait via les comptes WCA.
Le plus simple pour développer en local reste de faire tourner le site de la WCA en local (car vous pourrez vous logguer comme n'importe quel utilisateur).
Dans tous les cas il faut créer une application Oauth sur l'instance du site de la WCA que vous ciblez (locale, ou la production), cela ce fait [ici](https://www.worldcubeassociation.org/oauth/applications) pour sur le site "production" de la WCA.
L'URL de callback est la page gérant l'authentification sur le site de l'AFS, en local il s'agit de `http://127.0.0.1:3000/wca_callback` (par défaut le serveur tourne sur le port 3000, à adapter si besoin).

Une fois cela fait, il faudra ajouter l'id de l'application et le secret à l'environnement local ; le site peut charger des variables d'environnement depuis un fichier `.env`, il suffit donc de créer un fichier `.env` à la racine de ce dépôt.
Il contiendra par exemple ceci :

```bash
WCA_CLIENT_ID="example-application-id"
WCA_CLIENT_SECRET="example-secret"
# Adresse du site de la WCA à utiliser
# À commenter pour utiliser la version de production
WCA_BASE_URL="http://localhost:1234"
```

Il suffit ensuite de redémarrer le serveur pour qu'il prenne en compte ces variables d'environnement.

### Import des compétitions à venir

Elle se fait via `bin/rails scheduler:get_wca_competitions`.

Le script va essayer d'envoyer un mail aux "admins" du site pour notifier du succès ou de l'échec du script ; en développement local vous *devez* avoir un programme qui écoute sur le port 1025 (par exemple l'excellent [Mailcatcher](https://mailcatcher.me/)).
Si une compétition française a été annoncée la veille, ce script envoie également un email à toutes les personnes qui ont activé les notifications dans leur profil.


### Ajout d'un administrateur

Par défaut il n'y a aucun administrateur sur le site.
Connectez vous au moins une fois sur le site, puis ouvrez une console Rails via `bin/rails c`.
Si vous ne connaissez pas votre user id WCA, vous pouvez l'obtenir en regardant le dernier utilisateur ajouté (ici 277) :

```
irb(main):001:0> User.last
  User Load (0.7ms)  SELECT  "users".* FROM "users" ORDER BY "users"."id" DESC LIMIT $1  [["LIMIT", 1]]
=> #<User id: 277, name: "Philippe Virouleau", wca_id: "2008VIRO01", country_iso2: "FR", email: "277@worldcubeassociation.org", avatar_url: "http://localhost:1234/uploads/user/avatar/2008VIRO...", avatar_thumb_url: "http://localhost:1234/uploads/user/avatar/2008VIRO...", gender: "m", birthdate: "1954-12-04", created_at: "2018-05-17 13:35:29", updated_at: "2018-05-17 13:35:29", delegate_status: "delegate", admin: false, communication: false, french_delegate: false, notify_subscription: false>
```

Il suffit alors de mettre le champ `admin` à `true` manuellement :

```
irb(main):002:0> User.find(277).update(admin: true)
  User Load (0.9ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 277], ["LIMIT", 1]]
   (0.3ms)  BEGIN
  SQL (0.9ms)  UPDATE "users" SET "admin" = $1, "updated_at" = $2 WHERE "users"."id" = $3  [["admin", "t"], ["updated_at", "2018-05-17 13:40:37.844392"], ["id", 277]]
  ...
   (63.7ms)  COMMIT
=> true
```

Vous pouvez ensuite gérer les autres utilisateurs via l'interface du site.

### Lancer des migrations

Via le standard `bin/rails db:migrate`.

## Production

Voir la [page du wiki dédiée](https://github.com/speedcubingfrance/speedcubingfrance.org/wiki/Serveur-de-production-AFS).

## Sendgrid


Sendgrid est utilisé pour envoyer des emails depuis la production.

La seule chose à savoir est qu'il faut mettre en place l'API key pour que le système d'envoi de mail fonctionne.

Le dashboard est là : https://app.sendgrid.com/
(cf les logins/mdp)

Pour tester l'envoi de mail en local, il suffit de démarrer `mailcatcher` (en local les emails sont envoyés au smtp localhost).


