class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :model_id
      t.string  :model_type

      t.timestamps
    end
    add_index :accounts, [:model_id, :model_type]
  end
end
