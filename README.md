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

L'environnement de développement peut se lancer via docker compose :

```
docker compose up
```

Qui lancera les 4 services et le volume.
Le volume contient la base de données.

Les 4 services sont :
  - un service `database`, qui fait tourner postgresql.
  - un service `rails_webpacker` pour faire tourner webpacker, qui n'a pas besoin de db, et ne dépend donc pas du service `database`.
  - un service `rails`, qui fait tourner le serveur, et qui communique avec le service `database`
  - un service `rails_shell`, qui permet d'obtenir un shell dans le même environnement que le serveur rails.
  Ce dernier service permet donc d'aller lancer un `bin/rails console` pour aller inspecter l'application, mais également de lancer des commandes postgres.
  Pour démarrer le shell dans un conteneur temporaire, il suffit de lancer `docker compose run --rm rails_shell`.

Pour importer la base de prod, il suffit d'exécuter dans ce shell:

```
pg_restore --verbose --clean --no-acl --no-owner -h database -U speedcubingfrance -d speedcubingfrance-dev prod.dump
```

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

## Envoi d'email

Le SMTP de gmail est utilisé pour les envois d'email depuis la production.
J'ai (Philippe) créé un utilisateur `notifications@speedcubingfrance.org`, et ajouté un "routing" pour rejeter tous les messages entrant.
J'ai ensuite :
  - activé le 2FA pour le compte
  - ajouté un "mot de passe d'application" pour le compte

C'est ce mot de passe d'application qui est dans les secrets du site.
Pour le reste il a suffit de configurer rails pour utiliser le bon smtp.

Pour tester l'envoi de mail en local, il suffit de démarrer `mailcatcher` (en local les emails sont envoyés au smtp localhost).
