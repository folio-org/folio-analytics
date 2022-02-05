
These are transitional table queries that help with migration to
Metadb by providing tables that are compatible with LDP 1.x queries.
They are intended to be run in a Metadb database every evening until
all legacy queries have been migrated to use the new Metadb tables.

The search_path should be set when loading the tables as:

```bash
psql -c 'set search_path = public' -f <sqlfile>
```

If you find an error in these tables, or if your installation of LDP
1.x has a column that has been omitted here, please [submit a pull
request](../../CONTRIBUTING.md) with the correction/addition.

These tables are created using the same pattern as derived tables, and
with the following additional rules:

* Each table should emulate an existing table located in the `public`
  schema of a LDP 1.x database.
* Each table has only one "source table" in the `FROM` clause, which
  should be a Metadb table.  The source table should not end in `__t`
  or `__`.
* The first column is nearly always `id::varchar(36)`.
* The last column is nearly always `jsonb_pretty(jsonb)::json AS
  data`.
* All other columns are extracted from the `jsonb` column of the
  source table using `jsonb_extract_path_text()`.
* All columns extracted from `jsonb` should be simple data types from
  the top level of the JSON object; in other words, the same columns
  supported by LDP 1.x.
* Cast varchar columns to `varchar(65535)`, except for UUIDs (the
  field name ending in `Id`) which should be `varchar(36)`.
* Cast Boolean columns to `boolean`.
* Cast timestamps with time zone to `timestamptz`.
* Cast numeric values used in finance to `numeric(12,2)`.
* Create an index on each column, except for `id` and `data`.
* Define the `id` column as a primary key using: `ALTER TABLE
  <tablename> ADD PRIMARY KEY (id);`.
* SQL files are added to runlist.txt in alphabetical order rather than
  in dependency order (since there are no dependencies).
