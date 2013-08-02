{ for USER in dev tst prd; do echo "DROP USER ruby${USER} CASCADE;"; done } | sqlplus system/password;
{ for TS in DEV TST PRD; do echo -e "DROP TABLESPACE \"SAMPLE_APP_${TS}\"\n/\nDROP TABLESPACE \"SAMPLE_APP_${TS}_INDEX\"\n/\n"; done } | sqlplus system/password
FILE="oracle-users.sql"
echo "QUIT;" | sqlplus / as sysdba @ ${FILE}.new
for R_ENV in "production" "development" "test"; do rake db:migrate RAILS_ENV=${R_ENV}; done

