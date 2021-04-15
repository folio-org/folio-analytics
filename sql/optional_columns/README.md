
The SQL script `add_columns.sql` adds columns in the `public` schema
that may be optional or missing.  This allows queries that reference
those columns to run without error even if no data are available for
the columns.

This script is intended to be run nightly, after an LDP update but
before derived table queries are run.

The script should be run as `ldpadmin` (or equivalent) user, with
`ON_ERROR_STOP` set to `off` (the default), and not in a transaction
so that individual `ALTER TABLE` commands are allowed to fail (and the
script to continue) if the column exists.

Error messages such as
```
ERROR:  column <column_name> of relation <table_name> already exists
```
are completely normal and can be ignored.

Note to contributors:  The `ALTER TABLE` commands are alphabetized by
table name and column name.

