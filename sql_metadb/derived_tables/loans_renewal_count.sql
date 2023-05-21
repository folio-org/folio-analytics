--metadb:table loans_renewal_count
--metadb:require folio_circulation.loan__t.renewal_count numeric

DROP TABLE IF EXISTS loans_renewal_count;

-- Create a derived table that contains all items from inventory_items
-- and adds circulation info (total loans and renewals) from
-- circulation_loans; add in a date to show when the report was last
-- run and fill circulation nulls with zero.
CREATE TABLE loans_renewal_count AS
WITH loan_count AS (
    SELECT
        item_id::uuid,
        count(DISTINCT id::uuid) AS num_loans,
        sum(renewal_count::bigint)::bigint AS num_renewals
    FROM
        folio_circulation.loan__t
    GROUP BY
        item_id
)
SELECT
    CURRENT_DATE AS current_as_of_date,
    it.id::uuid AS item_id,
    coalesce(lc.num_loans, 0) AS num_loans,
    coalesce(lc.num_renewals, 0) AS num_renewals
FROM
    folio_inventory.item AS it
    LEFT JOIN loan_count AS lc ON it.id::uuid = lc.item_id;

CREATE INDEX ON loans_renewal_count (current_as_of_date);

CREATE INDEX ON loans_renewal_count (item_id);

CREATE INDEX ON loans_renewal_count (num_loans);

CREATE INDEX ON loans_renewal_count (num_renewals);

