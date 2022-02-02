Notes on migrating FOLIO queries from LDP 1.x to Metadb
=======================================================

##### Contents  
1\. [Metadb version](#1-show-metadb-version)  
2\. [Table and column names](#2-table-and-column-names)  
3\. [Data types](#3-data-types)  
4\. [JSON queries](#4-json-queries)


1\. Metadb version
------------------

Beginning with Metadb v0.12.0, it will be possible to query the Metadb
version with:

```sql
SELECT version FROM metadb.init;
```
```
    version     
----------------
 Metadb v0.12.0
```

Prior to Metadb v0.12.0, this will return an error: `permission denied
for schema metadb`.  LDP 1.x does not have an equivalent function for
users.


2\. Table and column names
--------------------------

Table names have changed to match FOLIO names more closely.  These
changes are being documented in a
[spreadsheet](https://docs.google.com/spreadsheets/d/19iP5hnUHqCuGMM5OQKdUWMNCT75ZK3EDa0Vx8LgUZ24/edit?usp=sharing).

The `data` column in LDP 1.x stores JSON objects provided by FOLIO.
In Metadb this column appears as `jsonb` or in some cases `content`,
again to match FOLIO names.


3\. Data types
--------------

In Metadb, UUIDs are generally stored using the `uuid` data type.  In
queries, UUIDs extracted as text should be converted with `::uuid`.

The `json` data type in LDP 1.x has changed to `jsonb` in Metadb.


4\. JSON queries
----------------

### JSON source data

To select JSON data extracted from a FOLIO source, LDP 1.x supports:

```sql
SELECT data FROM user_groups;
```

In Metadb, this can be written as:

```sql
SELECT jsonb FROM folio_users.groups;
```

Or with more human-readable formatting:

```sql
SELECT jsonb_pretty(jsonb) FROM folio_users.groups;
```

### JSON fields: non-array data

For non-array JSON fields, extracting the data directly from JSON in
LDP 1.x usually takes the form:

```sql
SELECT json_extract_path_text(data, 'group') FROM user_groups;
```

The equivalent for Metadb is either:

```sql
SELECT jsonb_extract_path_text(jsonb, 'group') FROM folio_users.groups;
```

Or:

```sql
SELECT jsonb->>'group' FROM folio_users.groups;
```

### JSON fields: array data

To extract JSON arrays, the syntax for Metadb is similar to LDP 1.x.
A lateral join can be used with the function `jsonb_array_elements()`
to convert the elements of a JSON array to a set of rows, one row per
array element.

For example, if the array elements are simple `varchar` strings:

```sql
CREATE TABLE instance_format_ids AS
SELECT
    id AS instance_id,
    instance_format_ids.jsonb #>> '{}' AS instance_format_id,
    instance_format_ids.ordinality
FROM
    folio_inventory.instance
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(jsonb, 'instanceFormatIds')) WITH ORDINALITY
        AS instance_format_ids (jsonb);
```

If the array elements are JSON objects:

```sql
CREATE TABLE holdings_notes AS
SELECT
    id AS holdings_id,
    (jsonb_extract_path_text(notes.jsonb, 'holdingsNoteTypeId'))::uuid AS holdings_note_type_id,
    jsonb_extract_path_text(notes.jsonb, 'note') AS note,
    (jsonb_extract_path_text(notes.jsonb, 'staffOnly'))::boolean AS staff_only,
    notes.ordinality
FROM
    folio_inventory.holdings_record
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(jsonb, 'notes')) WITH ORDINALITY
        AS notes (jsonb);
```

### JSON fields as columns

LDP 1.x transforms simple, first-level JSON fields into columns, which
can be queried as:

```sql
SELECT expiration_offset_in_days FROM user_groups;
```

The Metadb equivalent of this query is:

```sql
SELECT expiration_offset_in_days FROM folio_users.groups__t;
```

(This feature is not yet enabled by default as of Metadb
v0.11.0-beta2.)

Support for transforming subfields and arrays is also planned in
Metadb.

