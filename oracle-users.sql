-- Do *NOT* forget to change all $DIRECTORY_DATA$ and $DIRECTORY_INDEX$
--   by the actual directory, e.g.: 
-- FILE="oracle-users.sql"; sed -e 's/\$DIRECTORY_DATA\$/\/u01\/app\/oracle\/oradata\/orcl/g' -e 's/\$DIRECTORY_INDEX\$/\/u01\/app\/oracle\/oradata\/orcl/g' -e 's/"TEMPORARY"/"TEMP"/g' ${FILE} > ${FILE}.new; diff ${FILE} ${FILE}.new
-- echo "QUIT;" | sqlplus system/password @ ${FILE}.new
--
-- To drop all users:
--   { for USER in dev tst prd; do echo "DROP USER \"ruby${USER}\" CASCADE;"; done } | sqlplus system/password;
-- To drop all tables:
--   { for TS in dev tst prd; do echo -e "DROP TABLESPACE \"sample_app_${TS}\"\n/\nDROP TABLESPACE \"sample_app_${TS}_index\"\n/\n"; done } | sqlplus system/password
--
--
--
-- development
-- user: rubydev
-- pass: rubydev
-- schema: sample_app_dev
CREATE TABLESPACE "sample_app_dev"
    LOGGING
    DATAFILE '$DIRECTORY_DATA$/sample_data_dev.dbf' SIZE 100M
    REUSE EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT  AUTO
/
CREATE TABLESPACE "sample_app_dev_index"
    LOGGING
    DATAFILE '$DIRECTORY_INDEX$/sample_data_dev_index.dbf' SIZE 20M
    REUSE EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT  AUTO
/
CREATE USER "rubydev"  PROFILE "DEFAULT"
    IDENTIFIED BY rubydev DEFAULT TABLESPACE "sample_app_dev"
    TEMPORARY TABLESPACE "TEMP"
    QUOTA UNLIMITED
    ON "sample_app_dev"
    QUOTA UNLIMITED
    ON "sample_app_dev_index"
    ACCOUNT UNLOCK
/
GRANT CONNECT TO "rubydev"
/
GRANT RESOURCE TO "rubydev"
/
GRANT CREATE TABLE TO "rubydev"
/
GRANT CREATE SEQUENCE TO "rubydev"
/
REVOKE UNLIMITED TABLESPACE FROM "rubydev"
/
-- test
-- user: rubytst
-- pass: rubytst
-- schema: sample_app_tst
CREATE TABLESPACE "sample_app_tst"
    LOGGING
    DATAFILE '$DIRECTORY_DATA$/sample_data_tst.dbf' SIZE 100M
    REUSE EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT  AUTO
/
CREATE TABLESPACE "sample_app_tst_index"
    LOGGING
    DATAFILE '$DIRECTORY_INDEX$/sample_data_tst_index.dbf' SIZE 20M
    REUSE EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT  AUTO
/
CREATE USER "rubytst"  PROFILE "DEFAULT"
    IDENTIFIED BY rubytst DEFAULT TABLESPACE "sample_app_tst"
    TEMPORARY TABLESPACE "TEMP"
    QUOTA UNLIMITED
    ON "sample_app_tst"
    QUOTA UNLIMITED
    ON "sample_app_tst_index"
    ACCOUNT UNLOCK
/
GRANT CONNECT TO "rubytst"
/
GRANT RESOURCE TO "rubytst"
/
GRANT CREATE TABLE TO "rubytst"
/
GRANT CREATE SEQUENCE TO "rubytst"
/
REVOKE UNLIMITED TABLESPACE FROM "rubytst"
/
-- production
-- user: rubyprd
-- pass: rubyprd
-- schema: sample_app_prd
CREATE TABLESPACE "sample_app_prd"
    LOGGING
    DATAFILE '$DIRECTORY_DATA$/sample_data_prd.dbf' SIZE 100M
    REUSE EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT  AUTO
/
CREATE TABLESPACE "sample_app_prd_index"
    LOGGING
    DATAFILE '$DIRECTORY_INDEX$/sample_data_prd_index.dbf' SIZE 20M
    REUSE EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT  AUTO
/
CREATE USER "rubyprd"  PROFILE "DEFAULT"
    IDENTIFIED BY rubyprd DEFAULT TABLESPACE "sample_app_prd"
    TEMPORARY TABLESPACE "TEMP"
    QUOTA UNLIMITED
    ON "sample_app_prd"
    QUOTA UNLIMITED
    ON "sample_app_prd_index"
    ACCOUNT UNLOCK
/
GRANT CONNECT TO "rubyprd"
/
GRANT RESOURCE TO "rubyprd"
/
GRANT CREATE TABLE TO "rubyprd"
/
GRANT CREATE SEQUENCE TO "rubyprd"
/
REVOKE UNLIMITED TABLESPACE FROM "rubyprd"
/
-- quota
ALTER USER "rubydev" QUOTA 100M ON "sample_app_dev"
/
ALTER USER "rubytst" QUOTA 100M ON "sample_app_tst"
/
ALTER USER "rubyprd" QUOTA 100M ON "sample_app_prd"
/
