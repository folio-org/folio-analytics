
LDP 1.2 supports adding table columns in the `public` schema that may
be optional or missing.  This allows queries that reference the
columns to run without error even if no data are available for the
columns.

The configuration file `ldp_column.conf` contains a suggested list of
columns to be added, compiled by the FOLIO reporting community, in a
format that can be read by LDP.  See "Optional columns" in the [LDP
Administrator
Guide](https://github.com/library-data-platform/ldp/blob/main/doc/Admin_Guide.md)
for details.

Note to contributors:  The file is alphabetized by table name and
column name.

