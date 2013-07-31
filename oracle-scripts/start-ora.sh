lsnrctl start
sqlplus / as sysdba << __END__
STARTUP;
EXIT;
__END__
