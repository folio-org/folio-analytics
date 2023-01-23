# Select approved purchase orders billed to a specified entity

Each purchase order in table `folio_orders.purchase_order__t` is
"billed to" an entity stored in table
`folio_configuration.config_data__t`; however, the latter table also
contains various other, unrelated entities.  We can select all
entities that currently have a purchase order billed to them:

```sql
SELECT id,
       value::jsonb->>'name' AS bill_to_name
    FROM folio_configuration.config_data__t
    WHERE id = ANY (SELECT bill_to FROM folio_orders.purchase_order__t);
```

If we put this query into a CTE, we can then use the column
`bill_to_name` (and `approval_date`) to select approved purchased
orders billed to a specific entity, and sort them by approval date
with the most recent listed first:

```sql
WITH bill_to_values AS MATERIALIZED (
    SELECT id,
           value::jsonb->>'name' AS bill_to_name
        FROM folio_configuration.config_data__t
        WHERE id = ANY (SELECT bill_to FROM folio_orders.purchase_order__t)
)
SELECT p.id,
       p.approval_date,
       p.po_number
    FROM folio_orders.purchase_order__t AS p
        JOIN bill_to_values AS b ON p.bill_to = b.id
    WHERE p.approval_date IS NOT NULL AND b.bill_to_name = 'Acquisitions'
    ORDER BY p.approval_date DESC;
```

Note the CTE keyword `MATERIALIZED`.  This is needed here because
`folio_configuration.config_data__t` contains an assortment of JSON
objects, some of which do not contain the field `name`.  Normally the
database system will try to optimize the query by filtering on
`b.bill_to_name = 'Acquisitions'` at the same time as extracting the
`name` field, which generates an error for JSON objects that do not
have `name`.  The `MATERIALIZED` keyword tells the database system to
evaluate the CTE completely before proceeding to the main query where
the filtering on `name` takes place.

## Authors

Jean Pajerek

Nassib Nassar
