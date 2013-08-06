class RecreateRelationshipForVpd < ActiveRecord::Migration

  def up
    view = "relationships"
    table = "mt_#{view}"
    columns = %w(id follower_id followed_id created_at updated_at)
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
    drop_table :relationships
    create_table :mt_relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.references :tenant
      t.timestamps
    end
    add_index :mt_relationships, :follower_id
    add_index :mt_relationships, :followed_id
    add_index :mt_relationships, [:follower_id, :followed_id], unique: true
  end
end
