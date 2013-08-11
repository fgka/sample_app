-- To create the databases, execute the following:
--    mysql -u root -p < create_db.sql
--
-- Development:
-- sampleapp_dev
-- user: rubydev
-- pass: rubydev
DROP DATABASE IF EXISTS sampleapp_dev;
CREATE DATABASE sampleapp_dev CHARACTER SET utf8;
GRANT
    SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, INDEX, LOCK TABLES,
    CREATE VIEW, SHOW VIEW, ALTER ROUTINE, CREATE ROUTINE, EXECUTE, TRIGGER
        ON sampleapp_dev.* TO 'rubydev'@'localhost' IDENTIFIED BY 'rubydev';
FLUSH PRIVILEGES;
-- Test:
-- sampleapp_tst
-- user: rubyts
-- pass: rubytst
DROP DATABASE IF EXISTS sampleapp_tst;
CREATE DATABASE sampleapp_tst CHARACTER SET utf8;
GRANT
    SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, INDEX, LOCK TABLES,
    CREATE VIEW, SHOW VIEW, ALTER ROUTINE, CREATE ROUTINE, EXECUTE, TRIGGER
        ON sampleapp_tst.* TO 'rubytst'@'localhost' IDENTIFIED BY 'rubytst';
FLUSH PRIVILEGES;
-- Production:
-- sampleapp_prd
-- user: rubyprd
-- pass: rubyprd
DROP DATABASE IF EXISTS sampleapp_prd;
CREATE DATABASE sampleapp_prd CHARACTER SET utf8;
GRANT
    SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, INDEX, LOCK TABLES,
    CREATE VIEW, SHOW VIEW, ALTER ROUTINE, CREATE ROUTINE, EXECUTE, TRIGGER
        ON sampleapp_prd.* TO 'rubyprd'@'localhost' IDENTIFIED BY 'rubyprd';
FLUSH PRIVILEGES;
--
-- Just checking
--
USE mysql;
SELECT db, user FROM db WHERE db LIKE 'sampleapp_%';
SELECT user, host FROM user WHERE user LIKE 'ruby%';
