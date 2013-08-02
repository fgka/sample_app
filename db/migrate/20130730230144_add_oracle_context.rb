class AddOracleContext < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE OR REPLACE CONTEXT tenant_ctx USING tenant_ctx_pkg
    SQL

    execute <<-SQL
      CREATE OR REPLACE PACKAGE tenant_ctx_pkg IS
        FUNCTION set_tenant_id(tenant_id IN NUMBER) RETURN NUMBER;
        FUNCTION clear_tenant_id RETURN NUMBER;
        END;
    SQL

    execute <<-SQL
      CREATE OR REPLACE PACKAGE BODY tenant_ctx_pkg IS
        ret_tenant_id NUMBER := NULL;
        FUNCTION set_tenant_id(tenant_id IN NUMBER)
        RETURN NUMBER
        IS
        BEGIN
          DBMS_SESSION.SET_CONTEXT('tenant_ctx', 'tenant_id', tenant_id);
          SELECT SYS_CONTEXT('tenant_ctx', 'tenant_id') INTO ret_tenant_id FROM dual;
          RETURN ret_tenant_id;
        END set_tenant_id;
        FUNCTION clear_tenant_id
        RETURN NUMBER
        IS
        BEGIN
          SELECT SYS_CONTEXT('tenant_ctx', 'tenant_id') INTO ret_tenant_id FROM dual;
          DBMS_SESSION.SET_CONTEXT('tenant_ctx', 'tenant_id', NULL);
          RETURN ret_tenant_id;
        END clear_tenant_id;
      END;
    SQL
  end

  def down
    execute <<-SQL
      DROP PACKAGE tenant_ctx_pkg
    SQL

    execute <<-SQL
      DROP CONTEXT tenant_ctx
    SQL
  end
end
