class AddGetCtxTenantFunction < ActiveRecord::Migration
  def up
    execute <<-SQL
    CREATE OR REPLACE FUNCTION get_ctx_tenant(
      schema_p   IN VARCHAR2,
      table_p    IN VARCHAR2)
     RETURN VARCHAR2
     AS
      tenant_pred VARCHAR2 (400);
     BEGIN
      tenant_pred := 'tenant_id = SYS_CONTEXT(''tenant_ctx'', ''tenant_id'')';
     RETURN tenant_pred;
    END;
    SQL
  end

  def down
    execute <<-SQL
      DROP FUNCTION get_ctx_tenant;
    SQL
  end
end
