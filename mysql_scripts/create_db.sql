-- Development:
-- sampleapp_dev
-- user: rubydev
-- pass: rubydev
CREATE DATABASE sampleapp_dev CHARACTER SET utf8;
GRANT
    SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, INDEX, LOCK TABLES,
    CREATE VIEW, SHOW VIEW, ALTER ROUTINE, CREATE ROUTINE, EXECUTE
        ON sampleapp_dev.* TO 'rubydev'@'localhost' IDENTIFIED BY 'rubydev';
FLUSH PRIVILEGES;
-- Test:
-- sampleapp_tst
-- user: rubyts
-- pass: rubytst
CREATE DATABASE sampleapp_tst CHARACTER SET utf8;
GRANT
    SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, INDEX, LOCK TABLES,
    CREATE VIEW, SHOW VIEW, ALTER ROUTINE, CREATE ROUTINE, EXECUTE
        ON sampleapp_tst.* TO 'rubytst'@'localhost' IDENTIFIED BY 'rubytst';
FLUSH PRIVILEGES;
-- Production:
-- sampleapp_prd
-- user: rubyprd
-- pass: rubyprd
CREATE DATABASE sampleapp_prd CHARACTER SET utf8;
GRANT
    SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, INDEX, LOCK TABLES,
    CREATE VIEW, SHOW VIEW, ALTER ROUTINE, CREATE ROUTINE, EXECUTE
        ON sampleapp_prd.* TO 'rubyprd'@'localhost' IDENTIFIED BY 'rubyprd';
FLUSH PRIVILEGES;
