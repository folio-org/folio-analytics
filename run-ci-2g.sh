#!/bin/bash
set -e
cd sql_metadb/derived_tables
ls -l runlist.txt
for f in $( cat runlist.txt ); do
	if ! PGOPTIONS='--client-min-messages=warning' psql -bq -v ON_ERROR_STOP=on -d reports_dev -f $f ; then
		exit 1
	fi
done || exit 1
