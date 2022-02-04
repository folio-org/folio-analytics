
These are transitional tables to help with migration to Metadb.  They
are intended to be loaded into a Metadb database.

The search_path should be set when loading the tables as:

```bash
psql -c 'set search_path = public'
```
