FOLIO Reporting Derived Tables
==============================

These queries create "derived tables" which are helper tables to
simplify writing ad hoc queries.

The tables are created in the schema `folio_reporting`.  We suggest
granting full permissions to the `ldp` user, as in the examples below,
but this is not required.

Before running the queries for the first time, the schema should be
created:

```sql
CREATE SCHEMA IF NOT EXISTS folio_reporting;

GRANT CREATE, USAGE ON SCHEMA folio_reporting TO ldp;
```

There are various ways the queries can be executed.  The simplest
method might be:

```shell
cd folio-analytics/sql/derived_tables
git checkout 0.9-release
git pull
cat *.sql > all.tmp
psql ldp -U ldp -a -f all.tmp
```

The queries should be rerun every night after the LDP full update
completes, so that the derived tables will be recreated with the
latest data.

