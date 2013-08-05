RAILS_ENV=${1}
rake db:drop RAILS_ENV=${RAILS_ENV}
rake db:create RAILS_ENV=${RAILS_ENV}
rake db:migrate RAILS_ENV=${RAILS_ENV}
