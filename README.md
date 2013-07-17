# Ruby on Rails Tutorial: sample application

This is the sample application for
[*Ruby on Rails Tutorial: Learn Rails by Example*](http://railstutorial.org/)
by [Michael Hartl](http://michaelhartl.com/).

Do the following before continuing:

rake db:drop:all
rake db:create:all
rake db:migrate RAILS_ENV=development
rake db:migrate RAILS_ENV=test
rake db:migrate RAILS_ENV=production
# see libs/tasks/sample_data.rake
rake db:populate RAILS_ENV=development
