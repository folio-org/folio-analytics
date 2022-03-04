#!/bin/bash
#
# Set the following environment variables before running this script:
#
#     PGHOST - e.g. "glintcore.net"
#     PGDATABASE - e.g. "folio_juniper" or "folio_snapshot"
#     PGUSER - database user name
#
# For example:
#
#     $ cd sql_metadb/derived_tables/
#     $ PGHOST=glintcore.net PGDATABASE=folio_juniper PGUSER=nrn ../../testall.sh
#
set -e
# Check that the runlist exists.
if [[ ! -f runlist.txt ]]; then
    echo "testall.sh: runlist.txt not found" 1>&2
    exit 1
fi
# Check for duplicates in runlist.
if [[ $(sort runlist.txt | uniq -d) ]]; then
    echo "testall.sh: runlist.txt contains duplicates: `sort runlist.txt | uniq -d`" 1>&2
    exit 1
fi
# Run all queries.
tmpfile=`mktemp --tmpdir=. testall-XXXXXXXXXX.tmp`
trap 'rm -f -- "$tmpfile"' EXIT
for f in $( cat runlist.txt ); do
    if ! PGOPTIONS='--client-min-messages=warning' /usr/bin/time -o $tmpfile -f '%es' psql -c '\set ON_ERROR_STOP on' -f $f -Xq ; then
        exit 1
    fi
    printf 'ok\t%-50s\t%s\n' $f `cat $tmpfile` 1>&2
done || exit 1