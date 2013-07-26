class AddTenantToMicroposts < ActiveRecord::Migration
  def change
    change_table(:microposts) do |t|
      t.references :tenant
    end
    add_index :microposts, :tenant_id
  end
end
