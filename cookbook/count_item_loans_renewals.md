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

Since some items may never have been loaned at all, those items would
not be included in `folio_circulation.loan__t` and therefore would be
missing from the previous result.  To solve this problem, we can get a
list of all of the items (from `folio_inventory.item__t`) and join the
items to the results from our previous query as a CTE `loan_count`.
(We have left the date range out of the CTE to make the query more
general.)

Note that the `coalesce()` function is used here to set 0 as a default
count for items that have no loan data.

```sql
WITH loan_count AS (
    SELECT item_id,
           coalesce(count(id), 0) AS loan_count,
           coalesce(sum(renewal_count), 0) AS renewal_count
        FROM folio_circulation.loan__t
        GROUP BY item_id
)
SELECT i.id AS item_id,
       coalesce(c.loan_count, 0) AS loan_count,
       coalesce(c.renewal_count, 0) AS renewal_count
    FROM folio_inventory.item__t AS i
        LEFT JOIN loan_count AS c ON i.id = c.item_id;
```
