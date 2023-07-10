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
