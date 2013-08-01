require 'oracle_vpd'
require 'rails'

module OracleVPD
  class Railtie < Rails::Railtie
    initializer :before_initialize do
      ActiveRecord::Base.send(:include, OracleVPD::Base)
      ActionController::Base.send(:include, OracleVPD::Control)
      #ActiveRecord::ConnectionAdapters::ConnectionPool.send(:include, OracleVPD::ConnectionPool)
    end
  end
end
