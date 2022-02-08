FOLIO Reporting Derived Tables
==============================

These queries create "derived tables" which are helper tables to
simplify writing ad hoc queries.

The tables should be created in a schema `folio_reporting`.

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

