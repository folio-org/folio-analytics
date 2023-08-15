
LDP supports adding table columns in the `public` schema that are
required by queries but are missing because they contain no data in
the FOLIO instance.  This allows queries that reference the columns to
run without error.

The configuration file `ldp2_add_column.conf` (or
`ldp1_add_column.conf` for LDP 1.x) contains a recommended list of
columns to be added, compiled by the FOLIO reporting community, in a
format that can be read by LDP.  The file should be copied to
`ldp_add_column.conf` in the LDP data directory.  See "Optional
columns" in the [LDP Administrator
Guide](https://github.com/library-data-platform/ldp/blob/main/doc/Admin_Guide.md)
for details.

Notes for contributors:

* The file is intended to be alphabetized by table name and column
  name.

* The column type should be chosen to match the data type of the
  corresponding field in FOLIO, in order to work correctly with
  queries that use the column.

