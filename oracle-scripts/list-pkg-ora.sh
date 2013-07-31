USER=${1}
PASS=${2:-$USER}

sqlplus ${USER}/${PASS} << __END__
COLUMN object_name FORMAT A20
COLUMN object_type FORMAT A20
SELECT object_name, object_type FROM user_objects WHERE object_type IN ( 'PROCEDURE', 'FUNCTION','PACKAGE', 'PACKAGE BODY', 'CONTEXT' );

CONN sys/password AS SYSDBA;
COLUMN object_name FORMAT A20
COLUMN policy_name FORMAT A20
COLUMN function FORMAT A20
SELECT object_name, policy_name, function FROM dba_policies WHERE OBJECT_OWNER = UPPER('${USER}');
__END__

