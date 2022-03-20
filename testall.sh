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
usage() {
    echo ''
    echo 'Usage:  PGHOST=<database-host> PGDATABASE=<database_name> PGUSER=<database_user> testall.sh [<flags>]'
    echo ''
    echo 'Flags:'
    echo '-h  Help'
    echo '-t  Print running time at the beginning of each output line'
}
fmttime='false'
while getopts 'JTcfhtvX' flag; do
    case "${flag}" in
        h) usage
            exit 1 ;;
        t) fmttime='true' ;;
        *) usage
            exit 1 ;;
    esac
done
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
# Check which operating system is running.
case "$(uname -s)" in
    Linux*)     tmpfile=`mktemp --tmpdir=. testall-XXXXXXXXXX.tmp`
                gnutime=/usr/bin/time ;;
    Darwin*)    tmpfile=`mktemp testall.XXXXXXXXXX`
                gnutime=gtime ;;
    *)          echo "testall.sh: unsupported operating system: `uname -s`" 1>&2
                exit 1 ;;
esac
# Run all queries.
trap 'rm -f -- "$tmpfile"' EXIT
if $fmttime; then
    gtimefmt='%e'
else
    gtimefmt='%es'
fi
for f in $( cat runlist.txt ); do
    if ! PGOPTIONS='--client-min-messages=warning' $gnutime -o $tmpfile -f $gtimefmt psql -c '\set ON_ERROR_STOP on' -f $f -Xq ; then
        exit 1
    fi
    if $fmttime; then
        printf '%s\t%-50s\n' `cat $tmpfile` $f
    else
        printf 'ok\t%-50s\t%s\n' $f `cat $tmpfile`
    fi
done || exit 1
