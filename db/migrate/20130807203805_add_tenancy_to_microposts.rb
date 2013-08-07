class AddTenancyToMicroposts < ActiveRecord::Migration
  def up
    add_column :microposts, :tenant_id, :integer
    table = "microposts"
    tenant_column = "tenant_id"
    tenant_function_name = "get_ctx_tenant"
    create_mt_triggers(table, tenant_column, tenant_function_name)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
