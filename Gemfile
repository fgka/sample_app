source 'https://rubygems.org'

gem 'rails', '3.2.13'
gem 'bootstrap-sass', '2.1'
gem 'bcrypt-ruby', '3.0.1'
gem 'faker', '1.0.1'
gem 'will_paginate', '3.0.3'
gem 'bootstrap-will_paginate', '0.0.6'
gem 'jquery-rails', '2.0.2'
gem 'devise', '2.1.2'
gem 'milia', '0.3.38'

gem 'annotate', '2.5.0', group: :development

group :development, :test do
  gem 'sqlite3', '1.3.5'
  gem 'rspec-rails', '2.11.0'
  gem 'rspec-expectations', '2.11.3'
  gem 'guard-rspec', '1.2.1'
  gem 'guard-spork', github: 'guard/guard-spork'
  gem 'childprocess', '0.3.9'
  gem 'spork', '0.9.2'  
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '3.2.5'
  gem 'coffee-rails', '3.2.2'
  gem 'uglifier', '1.2.3'
  gem 'therubyracer', '0.11.4', platforms: :ruby
end

group :test do
  gem 'capybara', '1.1.2'
  gem 'rb-inotify', '~> 0.9'
  gem 'libnotify', '0.5.9'
  gem 'factory_girl_rails', '4.1.0'
  gem 'cucumber-rails', '1.2.1', require: false
  gem 'database_cleaner', '0.7.0'
end

group :production do
  gem 'mysql2', '0.3.12'
end
