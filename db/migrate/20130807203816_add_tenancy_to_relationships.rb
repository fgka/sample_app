class AddTenancyToRelationships < ActiveRecord::Migration
  def up
    add_column :relationships, :tenant_id, :integer
    table = "relationships"
    tenant_column = "tenant_id"
    tenant_function_name = "get_ctx_tenant"
    create_mt_triggers(table, tenant_column, tenant_function_name)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
