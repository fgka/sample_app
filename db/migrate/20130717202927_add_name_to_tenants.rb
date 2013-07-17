class AddNameToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :name, :string
    add_index :tenants, :name
  end
end
