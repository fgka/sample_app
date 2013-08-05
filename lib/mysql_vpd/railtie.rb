require 'mysql_vpd'
require 'rails'

module MysqlVPD
  class Railtie < Rails::Railtie
    initializer :before_initialize do
      ActiveRecord::Base.send(:include, MysqlVPD::Base)
      ActionController::Base.send(:include, MysqlVPD::Control)
      #ActiveRecord::ConnectionAdapters::ConnectionPool.send(:include, MysqlVPD::ConnectionPool)
    end
  end
end
