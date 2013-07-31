lsnrctl stop
sqlplus / as sysdba << __END__
SHUTDOWN IMMEDIATE;
EXIT;
__END__
