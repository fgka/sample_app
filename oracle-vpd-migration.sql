--
-- Now the VPD stuff
-- Reference: http://docs.oracle.com/cd/B28359_01/network.111/b28531/vpd.htm#BABCAIJH
-- This goes into a raw SQL migration
--
--
-- To remove the context:
--  DROP CONTEXT tenant_ctx;
CREATE OR REPLACE CONTEXT tenant_ctx USING tenant_ctx_pkg
/
-- To remove the package:
--  DROP PACKAGE tenant_ctx_pkg;
CREATE OR REPLACE PACKAGE tenant_ctx_pkg IS
 PROCEDURE set_tenant_id(tenant_id IN NUMBER);
 PROCEDURE clear_tenant_id;
 END;
/
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
/

-- To remove the function:
--  DROP FUNCTION get_ctx_tenant;
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
/

--
-- CREATE TABLE my_table ( col_num NUMBER(4), col_secret VARCHAR2(20), tenant_id NUMBER );
-- INSERT INTO my_table VALUES ( 1234, 'Secret tenant 1', 1 );
-- INSERT INTO my_table VALUES ( 4321, 'Secret tenant 2', 2 );
-- SELECT * FROM my_table;

-- To remove the policy:
--  DBMS_RLS.DROP_POLICY (
--   --object_schema   => 'rubydev', -- if not specified the current is used
--   object_name     => 'my_table',
--   policy_name     => 'my_table_policy');
BEGIN
 DBMS_RLS.ADD_POLICY (
--  object_schema    => 'rubydev', -- if not specified the current is used
  object_name      => 'my_table', -- this must be done to each table that is suppose to be multi-tenant
  policy_name      => 'my_table_policy', -- an unique name in this table scope
--  function_schema  => 'rubydev', -- if not specified the current is used
  policy_function  => 'get_ctx_tenant',
  statement_types  => 'select, insert, update, delete');
END;
/

-- Test:
-- EXECUTE TENANT_CTX_PKG.SET_TENANT_ID(1);
-- SELECT * FROM my_table; -- just the row starting with 1234
-- EXECUTE TENANT_CTX_PKG.SET_TENANT_ID(2);
-- SELECT * FROM my_table; -- just the row starting with 4321
-- EXECUTE TENANT_CTX_PKG.CLEAR_TENANT_ID;
-- SELECT * FROM my_table; -- should return no rows

--
-- To test:
-- $ sqlplus / as sysdba
-- SQL> conn rubydev/rubydev
-- SQL> EXECUTE TENANT_CTX_PKG.SET_TENANT_ID(123);
-- SQL> SELECT SYS_CONTEXT('tenant_ctx', 'tenant_id') FROM DUAL;
--
-- Should yield:
--
--  SYS_CONTEXT('tenant_ctx','tenant_id')
--  --------------------------------------------------------------------------------
--  123
--
