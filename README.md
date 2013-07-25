# Ruby on Rails Tutorial: sample application

This is the sample application for
[*Ruby on Rails Tutorial: Learn Rails by Example*](http://railstutorial.org/)
by [Michael Hartl](http://michaelhartl.com/).

# Install Oracle 11g (Fedora)

## Procedure for Fedora:
[http://www.gka-linux.blogspot.com/2013/07/installing-oracle-enterprise.html](http://www.gka-linux.blogspot.com/2013/07/installing-oracle-enterprise.html)

## Install Oracle Instant Client for 11g (EXTREMELY IMPORTANT)
[http://www.oracle.com/technetwork/database/features/instant-client](http://www.oracle.com/technetwork/database/features/instant-client)

## Versions:
 * Fedora 18/19 (last full update: 2013-07-22)
 * Oracle

# Setup environment variables

For Bash based shells just add this to your `.bash_profile`:

	export ORACLE_BASE=/u01/app/oracle
	export ORACLE_HOME=${ORACLE_BASE}/product/11.2.0/dbhome_1
	export ORACLE_INSTANT_CLIENT=/usr/lib/oracle/11.2/client64/
	export ORACLE_SID=orcl
	export PATH=${PATH}:${ORACLE_HOME}/bin:/usr/sbin:${ORACLE_INSTANT_CLIENT}/bin
	export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${ORACLE_HOME}/lib:${ORACLE_INSTANT_CLIENT}/lib
	export CLASSPATH=${CLASSPATH}:${ORACLE_HOME}/JRE:${ORACLE_HOME}/jlib:${ORACLE_HOME}/rdbms/jlib:${ORACLE_INSTANT_CLIENT}/lib


