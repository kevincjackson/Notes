# Deployment Notes

## Three Computers

Modern apps use three computers (servers)

1.  Front End - can be any hosting service like Hostgator, Github Pages, etc. Serves static files such as HTML, CSS, and JS (including React).
2.  Server - requires web application hosting like Amazon Web Services, Heroku, Digital Ocean, or Engine Yard. Serves Node and Express for example.
3.  Database - requires web application hosting like Amazon Web Services, Heroku, Digital Ocean, or Engine Yard. Serves Postgres for example. Multiple apps can use the same database.

## Learning

Every service is different and uses their own language to describe their solutions. You just need to read the documentation on how to set up your app for their service. Understanding the three computer concept above is the most important thing.

## Which Service?

For playing around, portfolio apps, and minimum viable product apps, Heroku is the best because they provide convenient, fast solutions (think Rails convenience) for serving and scaling your application. After your app grows to have real usage, other providers will be more cost effective, but will require more planning and management.

## Heroku

For Heroku here's a good place start.
<https://devcenter.heroku.com/>

## Copying Code

```bash
$ git remote --help
$ git remote -a heroku https://git.heroku.com/example-location-12345.git
$ git remote -v # Show remote
$ git push heroku master # Copy code
```

## Checking on the the database

```bash
$ heroku addons # Show databases
$ heroku pg:psql # Command line db
$ heroku psql # Command line db. Same as above.
$ heroku pg:info # Shows location
$ heroku logs # Debug server problems
```

## Copying Databases

Example Backup (`dump`) and Restore (`restore`) commands

```bash
$ PGPASSWORD='' pg_dump -Fc --no-acl --no-owner -h localhost -U '' -d smart-brain > smartbrain.dump
$ heroku pg:backups:restore 'http://example.com/temp/db.dump' DATABASE_URL
```

## Resetting the database

Dropping databases (normal commands are not supported). Careful - these commands are destructive!

```sh
db:reset              # Not supported
heroku pg:reset       # Use instead
```

## Rails Deployment

1.  precompile assets
    `RAILS_ENV=production bundle exec rake assets:precompile`
2.  run all your tests
3.  git add & commit
4.  heroku login
5.  heroku create (if needed)
6.  git push heroku master
7.  heroku run rake db:migrate
8.  heroku open

Run commands on heroku (production)

```sh
heroku run rake <your command>
heroku run rake db:migrate VERSION=20081118092504
```
