class AddTenantToRelationships < ActiveRecord::Migration
  def change
    change_table(:relationships) do |t|
      t.references :tenant
    end
    add_index :relationships, :tenant_id
  end
end
