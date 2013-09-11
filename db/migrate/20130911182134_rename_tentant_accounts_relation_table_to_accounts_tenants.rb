class RenameTentantAccountsRelationTableToAccountsTenants < ActiveRecord::Migration
  def up
    drop_table :tenants_accounts
    create_table :accounts_tenants, :id => false  do |t|
      t.references :account
      t.references :tenant
    end
    add_index :accounts_tenants, :account_id
    add_index :accounts_tenants, :tenant_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
