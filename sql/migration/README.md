
These are transitional table queries to help with migration to Metadb.
They are intended to be run in a Metadb database every evening until
all legacy queries have been migrated to use the new Metadb tables.

The search_path should be set when loading the tables as:

```bash
psql -c 'set search_path = public' -f <sqlfile>
```
