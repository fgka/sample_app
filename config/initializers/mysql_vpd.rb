MysqlVPD.setup do |config|

  config.account_tables = [:user]
  config.tenant_table = :tenants

end
