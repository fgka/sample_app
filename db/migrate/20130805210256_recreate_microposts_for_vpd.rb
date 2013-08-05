class RecreateMicropostsForVpd < ActiveRecord::Migration
  def up
    recreate_table_mt_version
    drop_view "microposts"
    create_microposts_view "get_ctx_tenant"
    create_triggers "get_ctx_tenant"
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

  def drop_view(name)
    execute <<-SQL
    DROP VIEW IF EXISTS #{name};
    SQL
  end

  def create_microposts_view(tenant_function_name)
    execute <<-SQL
    CREATE VIEW microposts (
      id,
      content,
      user_id,
      created_at,
      updated_at
    )
    AS
    SELECT
      mt.id AS id,
      mt.content AS content,
      mt.user_id AS user_id,
      mt.created_at AS created_at,
      mt.updated_at AS updated_at
    FROM
      mt_microposts AS mt
    WHERE
      (mt.tenant_id = (SELECT #{tenant_function_name}()));
    SQL
  end

  def create_triggers(tenant_function_name)
    create_before_insert_trigger("microposts", tenant_function_name)
    create_before_update_trigger("microposts", tenant_function_name)
  end

  def create_before_insert_trigger(table, tenant_function_name)
    create_before_operation_trigger(table, "INSERT", tenant_function_name)
  end

  def create_before_update_trigger(table, tenant_function_name)
      create_before_operation_trigger(table, "UPDATE", tenant_function_name)
  end

  def create_before_operation_trigger(table, operation, tenant_function_name)
    trigger = "tr_#{table}_before_#{operation}".downcase
    drop_trigger trigger
    create_tenant_setting_trigger(trigger, operation.upcase, table, tenant_function_name)
  end

  def drop_trigger(name)
    execute <<-SQL
    DROP TRIGGER IF EXISTS #{name}
    SQL
  end

  def create_tenant_setting_trigger(name, operation, table, tenant_function_name)
    execute <<-SQL
    CREATE TRIGGER #{name}
    BEFORE #{operation}
    ON mt_#{table}
    FOR EACH ROW
    BEGIN
      SET NEW.tenant_id = (SELECT #{tenant_function_name}());
    END
    SQL
  end
end
