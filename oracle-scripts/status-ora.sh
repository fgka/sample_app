tnsping ORCL
lsnrctl status
sqlplus / as sysdba << __END__
SELECT DATABASE_STATUS FROM V\$INSTANCE;
EXIT;
__END__
