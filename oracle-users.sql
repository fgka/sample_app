-- Do *NOT* forget to change all $DIRECTORY_DATA$ and $DIRECTORY_INDEX$
--   by the actual directory, e.g.:
-- FILE="oracle-users.sql"; sed -e 's/\$DIRECTORY_DATA\$/\/u01\/app\/oracle\/oradata\/orcl/g' -e 's/\$DIRECTORY_INDEX\$/\/u01\/app\/oracle\/oradata\/orcl/g' -e 's/"TEMPORARY"/"TEMP"/g' ${FILE} > ${FILE}.new; diff ${FILE} ${FILE}.new
-- echo "QUIT;" | sqlplus / as sysdba @ ${FILE}.new
--
-- To drop all users:
--   { for USER in dev tst prd; do echo "DROP USER ruby${USER} CASCADE;"; done } | sqlplus system/password;
-- To drop all tables:
--   { for TS in DEV TST PRD; do echo -e "DROP TABLESPACE \"SAMPLE_APP_${TS}\"\n/\nDROP TABLESPACE \"SAMPLE_APP_${TS}_INDEX\"\n/\n"; done } | sqlplus system/password
--
--
-- development
-- user: rubydev
-- pass: rubydev
-- schema: SAMPLE_APP_DEV
CREATE TABLESPACE "SAMPLE_APP_DEV"
    LOGGING
    DATAFILE '$DIRECTORY_DATA$/SAMPLE_DATA_DEV.dbf' SIZE 100M
    REUSE EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT  AUTO
/
CREATE TABLESPACE "SAMPLE_APP_DEV_INDEX"
    LOGGING
    DATAFILE '$DIRECTORY_INDEX$/SAMPLE_DATA_DEV_INDEX.dbf' SIZE 20M
    REUSE EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT  AUTO
/
CREATE USER rubydev  PROFILE "DEFAULT"
    IDENTIFIED BY rubydev DEFAULT TABLESPACE "SAMPLE_APP_DEV"
    TEMPORARY TABLESPACE "TEMP"
    QUOTA UNLIMITED
    ON "SAMPLE_APP_DEV"
    QUOTA UNLIMITED
    ON "SAMPLE_APP_DEV_INDEX"
    ACCOUNT UNLOCK
/
GRANT CREATE SESSION, CREATE ANY CONTEXT, CREATE PROCEDURE, CREATE TRIGGER, ADMINISTER DATABASE TRIGGER TO rubydev
/
GRANT EXECUTE ON DBMS_SESSION TO rubydev
/
GRANT EXECUTE ON DBMS_RLS TO rubydev
/
GRANT RESOURCE TO rubydev
/
GRANT CREATE TABLE TO rubydev
/
GRANT CREATE SEQUENCE TO rubydev
/
REVOKE UNLIMITED TABLESPACE FROM rubydev
/
ALTER USER rubydev QUOTA 100M ON "SAMPLE_APP_DEV"
/
-- test
-- user: rubytst
-- pass: rubytst
-- schema: SAMPLE_APP_TST
CREATE TABLESPACE "SAMPLE_APP_TST"
    LOGGING
    DATAFILE '$DIRECTORY_DATA$/SAMPLE_DATA_TST.dbf' SIZE 100M
    REUSE EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT  AUTO
/
CREATE TABLESPACE "SAMPLE_APP_TST_INDEX"
    LOGGING
    DATAFILE '$DIRECTORY_INDEX$/SAMPLE_DATA_TST_INDEX.dbf' SIZE 20M
    REUSE EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT  AUTO
/
CREATE USER rubytst  PROFILE "DEFAULT"
    IDENTIFIED BY rubytst DEFAULT TABLESPACE "SAMPLE_APP_TST"
    TEMPORARY TABLESPACE "TEMP"
    QUOTA UNLIMITED
    ON "SAMPLE_APP_TST"
    QUOTA UNLIMITED
    ON "SAMPLE_APP_TST_INDEX"
    ACCOUNT UNLOCK
/
GRANT CREATE SESSION, CREATE ANY CONTEXT, CREATE PROCEDURE, CREATE TRIGGER, ADMINISTER DATABASE TRIGGER TO rubytst
/
GRANT EXECUTE ON DBMS_SESSION TO rubytst
/
GRANT EXECUTE ON DBMS_RLS TO rubytst
/
GRANT RESOURCE TO rubytst
/
GRANT CREATE TABLE TO rubytst
/
GRANT CREATE SEQUENCE TO rubytst
/
REVOKE UNLIMITED TABLESPACE FROM rubytst
/
ALTER USER rubytst QUOTA 100M ON "SAMPLE_APP_TST"
/
-- production
-- user: rubyprd
-- pass: rubyprd
-- schema: SAMPLE_APP_PRD
CREATE TABLESPACE "SAMPLE_APP_PRD"
    LOGGING
    DATAFILE '$DIRECTORY_DATA$/SAMPLE_DATA_PRD.dbf' SIZE 100M
    REUSE EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT  AUTO
/
CREATE TABLESPACE "SAMPLE_APP_PRD_INDEX"
    LOGGING
    DATAFILE '$DIRECTORY_INDEX$/SAMPLE_DATA_PRD_INDEX.dbf' SIZE 20M
    REUSE EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT  AUTO
/
CREATE USER rubyprd  PROFILE "DEFAULT"
    IDENTIFIED BY rubyprd DEFAULT TABLESPACE "SAMPLE_APP_PRD"
    TEMPORARY TABLESPACE "TEMP"
    QUOTA UNLIMITED
    ON "SAMPLE_APP_PRD"
    QUOTA UNLIMITED
    ON "SAMPLE_APP_PRD_INDEX"
    ACCOUNT UNLOCK
/
GRANT CREATE SESSION, CREATE ANY CONTEXT, CREATE PROCEDURE, CREATE TRIGGER, ADMINISTER DATABASE TRIGGER TO rubyprd
/
GRANT EXECUTE ON DBMS_SESSION TO rubyprd
/
GRANT EXECUTE ON DBMS_RLS TO rubyprd
/
GRANT RESOURCE TO rubyprd
/
GRANT CREATE TABLE TO rubyprd
/
GRANT CREATE SEQUENCE TO rubyprd
/
REVOKE UNLIMITED TABLESPACE FROM rubyprd
/
ALTER USER rubyprd QUOTA 100M ON "SAMPLE_APP_PRD"
/
