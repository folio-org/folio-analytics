#!/bin/bash
set -e
cd sql/derived_tables
for f in $( cat runlist.txt ); do
	psql -bq -v ON_ERROR_STOP=on -d folio_snapshot -f $f
done
