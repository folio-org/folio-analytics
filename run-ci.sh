#!/bin/bash
set -e
cd sql/derived_tables
# check for duplicates in runlist
if [[ $(sort runlist.txt | uniq -d) ]]; then
	echo "run-ci.sh: runlist.txt contains duplicates: `sort runlist.txt | uniq -d`"
	exit 1
fi
for f in $( cat runlist.txt ); do
	if ! PGOPTIONS='--client-min-messages=warning' psql -a -d folio_snapshot -c '\set ON_ERROR_STOP on' -c 'set search_path = folio_reporting,public' -f $f -U runner ; then
		exit 1
	fi
done || exit 1
