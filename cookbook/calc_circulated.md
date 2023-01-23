# Calculate the proportion of items that have been circulated

To get a rough idea of collection use, we can divide the number of
distinct items in loans (`folio_circulation.loan__t`) by the total
number of items (`folio_inventory.item__t`), and round the result to
two decimal places:

```sql
SELECT round(
           ( (SELECT count(DISTINCT item_id)::float FROM folio_circulation.loan__t) /
             (SELECT count(*)::float FROM folio_inventory.item__t) )::numeric,
           2) AS loan_quotient;
```

After performing the division, we cast the result to `numeric` because
that is the data type required by the `round()` function.
