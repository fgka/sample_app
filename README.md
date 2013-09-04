# Ruby on Rails Tutorial: sample application

This is the sample application for
[*Ruby on Rails Tutorial: Learn Rails by Example*](http://railstutorial.org/)
by [Michael Hartl](http://michaelhartl.com/).

Many thanks to [Daudi Amani](https://github.com/dsaronin) for the [milia](https://github.com/dsaronin/milia) gem.

# Install MySQL (Fedora)

## Versions:
 * Fedora 18/19 (last full update: 2013-07-22)
 * MySQL 5.5.32

# RESTRICITONS:

Do **NOT** use the following `rake` command:

 * `rake db:reset` this will destroy all views.

## How to reset the DB:

**ALWAYS** run the following for reseting the database:

`rake db:drop db:create db:migrate RAILS_ENV=test`

## How to (re)populate the DB for demos:

`rake db:drop db:create db:migrate db:populate RAILS_ENV=development`

# Running tests:

`rake db:drop db:create db:migrate RAILS_ENV=test; rspec spec/`

