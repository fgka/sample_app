class RenameTentantUsersRelationTableToTenantAccounts < ActiveRecord::Migration
  def up
    drop_table :tenants_users
    create_table :tenants_accounts, :id => false  do |t|
      t.references :tenant
      t.references :account
    end
    add_index :tenants_accounts, :tenant_id
    add_index :tenants_accounts, :account_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
