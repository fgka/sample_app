USER=${1}
TENANT=${2:-1}
PASS=${3:-$USER}

sqlplus ${USER}/${PASS} << __END__
CREATE OR REPLACE CONTEXT tenant_ctx USING tenant_ctx_pkg
/
EXECUTE tenant_ctx_pkg.set_tenant_id(${TENANT});
SET WRAP OFF;
COLUMN content FORMAT A20
SELECT user_id, tenant_id, COUNT(*) AS "# POSTS" FROM microposts GROUP BY user_id, tenant_id;
SELECT follower_id, followed_id, tenant_id FROM relationships;
__END__
