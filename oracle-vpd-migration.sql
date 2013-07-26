--
-- Now the VPD stuff
-- Reference: http://docs.oracle.com/cd/B28359_01/network.111/b28531/vpd.htm#BABCAIJH
-- This goes into a raw SQL migration
--
--
CREATE OR REPLACE CONTEXT tenant_ctx USING tenant_ctx_pkg
/
CREATE OR REPLACE PACKAGE tenant_ctx_pkg IS
 PROCEDURE set_tenant_id;
 PROCEDURE clear_tenant_id;
 END;
/
CREATE OR REPLACE PACKAGE BODY tenant_ctx_pkg IS
  PROCEDURE set_tenant_id(
    tenant_id IN NUMBER
  )
  AS
  BEGIN
     DBMS_SESSION.SET_CONTEXT('tenant_ctx', 'tenant_id', tenant_id);
  END set_tenant_id;
  PROCEDURE clear_tenant_id
  AS
  BEGIN
     DBMS_SESSION.SET_CONTEXT('tenant_ctx', 'tenant_id', NULL);
  END clear_tenant_id;
END;
/


