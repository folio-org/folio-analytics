FOLIO Reporting Derived Tables
==============================

These queries create "derived tables" which are helper tables to
simplify writing ad hoc queries.

The tables should be created in a schema `folio_reporting` owned by a
database user, for instance,`ldpreport`.  This user must have
privileges to `SELECT` from tables in the `public` schema.

```
CREATE SCHEMA folio_reporting;

ALTER SCHEMA folio_reporting OWNER TO ldpreport;

GRANT USAGE ON SCHEMA public TO ldpreport;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO ldpreport;
```

The search_path should be set when loading the tables as:

```bash
psql -c 'set search_path = folio_reporting, public' -f <sqlfile>
```

Note that the provided file `runlist.txt` lists all of the query files
in the order they should be run.  The order is significant because
some of the queries depend on the result of other queries.

The queries should be rerun every night after the LDP full update
completes, so that the derived tables will be recreated with the
latest data.

The sample script `derived_tables.sh` located in this directory can be
used to load the derived tables:

```bash
#!/bin/bash

# Set the following environment variables before running this script:
#
#   PGHOST - host name of LDP database
#   PGDATABASE - LDP database name
#   PGUSER - LDP database user name, e.g. ldpreport
#
# For example:
#
#   $ cd sql/derived_tables/
#   $ PGHOST=ldp.folio.org PGDATABASE=ldp PGUSER=ldpreport ./derived_tables.sh
#
# The password can be set in the psql configuration file: $HOME/.pgpass
#
# This script assumes that the LDP user is "ldp".

PGOPTIONS='--client-min-messages=warning' psql -Xq \
         -c '\set ON_ERROR_STOP on' \
         -c "GRANT USAGE ON SCHEMA folio_reporting TO ldp;"
for f in $( cat runlist.txt ); do
    PGOPTIONS='--client-min-messages=warning' psql -Xq -P pager \
             -c 'set search_path = folio_reporting, public' \
             -c '\set ON_ERROR_STOP on' -1 -f $f
    PGOPTIONS='--client-min-messages=warning' psql -Xq \
             -c '\set ON_ERROR_STOP on' \
             -c "GRANT SELECT ON ALL TABLES IN SCHEMA folio_reporting TO ldp;"
done
```
