class CreateTenantGetterFunction < ActiveRecord::Migration
  def up
    drop_function "get_ctx_tenant"
    create_function("get_ctx_tenant", "tenant_id")
  end

  def down
    drop_function 'get_ctx_tenant'
  end

  private

  def drop_function(name)
    execute <<-SQL
      DROP FUNCTION IF EXISTS #{name};
    SQL
  end

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
