require 'rails'
require 'mysql_vpd/tenant_helper'
require 'mysql_vpd/base'
require 'mysql_vpd/control'
require 'mysql_vpd/migration'
require 'mysql_vpd/connection_pool'

Rails.configuration.to_prepare do
  ActiveRecord::Base.send(:include, MysqlVPD::TenantHelper)
  ActionController::Base.send(:include, MysqlVPD::TenantHelper)

  ActiveRecord::Base.send(:include, MysqlVPD::Base)
  ActionController::Base.send(:include, MysqlVPD::Control)
  ActiveRecord::Migration.send(:include, MysqlVPD::Migration)
end
