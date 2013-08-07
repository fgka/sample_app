require 'rubygems'
require 'spork'
require 'factory_girl_rails'

Spork.prefork do
  ENV['RAILS_ENV'] ||= 'test'
  require File.expand_path('../../config/environment', __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'database_cleaner'
  require 'active_record'
  require 'active_record/connection_adapters/abstract_adapter'
  require 'active_record/connection_adapters/abstract_mysql_adapter'

  Dir[Rails.root.join('spec/support/**/*.rb')].each {|f| require f}

  RSpec.configure do |config|
    config.mock_with :rspec

    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    config.use_transactional_fixtures = false
    DatabaseCleaner[:active_record].strategy = :transaction
    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

    config.infer_base_class_for_anonymous_controllers = false

    config.include Devise::TestHelpers, :type => :controller

    config.expect_with :rspec do |c|
      c.syntax = [:should, :expect]
    end
  end
end
