class AddOracleContext < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE OR REPLACE CONTEXT tenant_ctx USING tenant_ctx_pkg
    SQL

    execute <<-SQL
      CREATE OR REPLACE PACKAGE tenant_ctx_pkg IS
        PROCEDURE set_tenant_id(tenant_id IN NUMBER);
        PROCEDURE clear_tenant_id;
        END;
    SQL

    execute <<-SQL
      CREATE OR REPLACE PACKAGE BODY tenant_ctx_pkg IS
        PROCEDURE set_tenant_id(
          tenant_id IN NUMBER
        ) IS
        BEGIN
          DBMS_SESSION.SET_CONTEXT('tenant_ctx', 'tenant_id', tenant_id);
        END set_tenant_id;
        PROCEDURE clear_tenant_id IS
        BEGIN
          DBMS_SESSION.SET_CONTEXT('tenant_ctx', 'tenant_id', NULL);
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
