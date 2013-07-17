class AddTenantToUsersTenantIndex < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      t.references :tenant
    end
     add_index :users, :tenant_id
  end
end
