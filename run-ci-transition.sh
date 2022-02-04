#!/bin/bash
set -e
#### Load transitional tables
cd sql/transition
# check for duplicates in runlist
if [[ $(sort runlist.txt | uniq -d) ]]; then
	echo "run-ci-transition.sh: sql/transition/runlist.txt contains duplicates: `sort runlist.txt | uniq -d`"
	exit 1
fi
for f in $( cat runlist.txt ); do
	if ! PGOPTIONS='--client-min-messages=warning' psql -bq -d reports_dev -c '\set ON_ERROR_STOP on' -c 'set search_path = public' -f $f ; then
		exit 1
	fi
done || exit 1
#### Run LDP 1.x derived tables
cd ../derived_tables
# check for duplicates in runlist
# if [[ $(sort runlist.txt | uniq -d) ]]; then
# 	echo "run-ci-transition.sh: sql/derived_tables/runlist.txt contains duplicates: `sort runlist.txt | uniq -d`"
# 	exit 1
# fi
# for f in $( cat runlist.txt ); do
# 	if ! PGOPTIONS='--client-min-messages=warning' psql -bq -d folio_snapshot -c '\set ON_ERROR_STOP on' -c 'set search_path = folio_reporting,public' -f $f ; then
# 		exit 1
# 	fi
# done || exit 1
