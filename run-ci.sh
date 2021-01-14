#!/bin/bash
set -e
cd sql/derived_tables
for f in $( cat runlist.txt ); do
	PGOPTIONS='--client-min-messages=warning' psql -bq -v ON_ERROR_STOP=on -d folio_snapshot -f $f
done
