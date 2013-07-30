require 'rails'
require 'oracle_vpd/base'
require 'oracle_vpd/control'

Rails.configuration.to_prepare do
  ActiveRecord::Base.send(:include, OracleVPD::Base)
  ActionController::Base.send(:include, OracleVPD::Control)
end

