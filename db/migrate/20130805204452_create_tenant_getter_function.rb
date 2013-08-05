class CreateTenantGetterFunction < ActiveRecord::Migration
  def up
    execute <<-SQL
    DROP FUNCTION IF EXISTS get_ctx_tenant;
    SQL
    execute <<-SQL
    CREATE FUNCTION get_ctx_tenant()
      RETURNS INTEGER
      LANGUAGE SQL
    BEGIN
      RETURN @tenant_id;
    END;
    SQL
  end

  def down
    execute <<-SQL
      DROP FUNCTION IF EXISTS get_ctx_tenant;
    SQL
  end
end
