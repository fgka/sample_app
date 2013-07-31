require 'rails'
require 'oracle_vpd/base'
require 'oracle_vpd/control'
require 'oracle_vpd/connection_pool_vpd'

Rails.configuration.to_prepare do
  ActiveRecord::Base.send(:include, OracleVPD::Base)
  ActionController::Base.send(:include, OracleVPD::Control)
  ActionController::Base.send(:include, OracleVPD::Control)
  ActiveRecord::ConnectionAdapters::ConnectionPool.send(:include, OracleVPD::ConnectionPoolVPD)
end

