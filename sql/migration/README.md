
These are transitional table queries that help with migration to
Metadb by providing tables that are compatible with LDP 1.x queries.
They are intended to be run in a Metadb database every evening until
all legacy queries have been migrated to use the new Metadb tables.

The search_path should be set when loading the tables as:

```bash
psql -c 'set search_path = public' -f <sqlfile>
```
