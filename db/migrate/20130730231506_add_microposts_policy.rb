class AddMicropostsPolicy < ActiveRecord::Migration
  def up
    execute <<-SQL
      BEGIN
        DBMS_RLS.ADD_POLICY (
          object_name      => 'microposts', -- this must be done to each table that is suppose to be multi-tenant
          policy_name      => 'microposts_policy', -- an unique name in this table scope
          policy_function  => 'get_ctx_tenant',
          statement_types  => 'select, insert, update, delete');
      END;
    SQL
  end

  def down
    execute <<-SQL
      DBMS_RLS.DROP_POLICY (
        object_name     => 'microposts',
        policy_name     => 'microposts_policy');
    SQL
  end
end
