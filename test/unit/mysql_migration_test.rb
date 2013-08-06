require './test/test_helper'

class UserTest < ActiveSupport::TestCase
   test "the truth" do
     assert true
   end
end

class MysqlMigrationTest < ActiveSupport::TestCase

  # Replace this with your real tests.
  test "create_multitenant_view" do
    view = "microposts"
    table = "mt_#{view}"
    columns = %w(id, content, user_id, created_at, updated_at)
    tenant_column = "tenant_id"
    tenant_function_name = "get_ctx_tenant"
    expected <<-SQL
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
      (mt.tenant_id = (SELECT #{function_name}()));
    SQL
    actual = sql_create_multitenant_view(view, table, columns, tenant_column, tenant_function_name)
    assert_equal(expected, actual)
  end

  test "do something" do
    assert true
  end
end
