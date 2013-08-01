require 'rails'
require 'oracle_vpd/base'
require 'oracle_vpd/control'
require 'oracle_vpd/connection_pool'

Rails.configuration.to_prepare do
  ActiveRecord::Base.send(:include, OracleVPD::Base)
  ActionController::Base.send(:include, OracleVPD::Control)
end
