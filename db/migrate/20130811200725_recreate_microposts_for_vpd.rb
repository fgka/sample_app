class RecreateMicropostsForVpd < ActiveRecord::Migration

  def up
    view = "microposts"
    table = "mt_#{view}"
    columns = %w(id content user_id created_at updated_at)
    tenant_column = "tenant_id"
    tenant_function_name = "get_ctx_tenant"

    recreate_table_mt_version
    create_mt_triggers(table, tenant_column, tenant_function_name)
    create_multitenant_view(view, table, columns, tenant_column, tenant_function_name)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def recreate_table_mt_version
    drop_table :microposts
    create_table :mt_microposts do |t|
      t.string :content
      t.integer :user_id
      t.references :tenant
      t.timestamps
    end
    add_index :mt_microposts, [:user_id, :created_at]
  end

end
