# Count number of loans and renewals of each item

To count loans, we can select the table `folio_circulation.loan__t`
and use the aggregate function `count()` to group loans having the
same `item_id`.  Counting renewals is similar except that each loan
can have multiple renewals, stored in the column `renewal_count`; so
we use the aggregate function `sum()` to add up the renewals.

This example counts loans and renewals in the date range `2022-01-01
<= loan_date < 2023-01-01`:

```sql
SELECT item_id,
       coalesce(count(id), 0) AS loan_count,
       coalesce(sum(renewal_count), 0) AS renewal_count
    FROM folio_circulation.loan__t
    WHERE loan_date >= '2022-01-01' AND loan_date < '2023-01-01'
    GROUP BY item_id;
```
