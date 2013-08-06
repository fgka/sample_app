class CreateTenantGetterFunction < ActiveRecord::Migration

  def up
    drop_function "get_ctx_tenant"
    create_function("get_ctx_tenant", "tenant_id")
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def create_function(name, variable)
    execute <<-SQL
    CREATE FUNCTION #{name}()
      RETURNS INTEGER
      LANGUAGE SQL
    BEGIN
      RETURN @#{variable};
    END;
    SQL
  end
end
