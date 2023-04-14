DROP TABLE IF EXISTS loans_renewal_count;

-- Create a derived table that contains all items from inventory_items
-- and adds circulation info (total loans and renewals) from
-- circulation_loans; add in a date to show when the report was last
-- run and fill circulation nulls with zero.
CREATE TABLE loans_renewal_count AS
WITH loan_count AS (
    SELECT
        item_id,
        count(DISTINCT id) AS num_loans,
        sum(json_extract_path_text(data, 'renewalCount')::bigint) AS num_renewals
    FROM
        circulation_loans
    GROUP BY
        item_id
)
SELECT
    CURRENT_DATE AS current_as_of_date,
    it.id AS item_id,
    it.hrid AS item_hrid,
    COALESCE(lc.num_loans, 0) AS num_loans,
    COALESCE(lc.num_renewals, 0) AS num_renewals
FROM
    inventory_items AS it
    LEFT JOIN loan_count AS lc ON it.id = lc.item_id;

CREATE INDEX ON loans_renewal_count (current_as_of_date);

CREATE INDEX ON loans_renewal_count (item_id);

CREATE INDEX ON loans_renewal_count (num_loans);

CREATE INDEX ON loans_renewal_count (num_renewals);

COMMENT ON COLUMN loans_renewal_count.current_as_of_date IS 'Current date when report was run';

COMMENT ON COLUMN loans_renewal_count.item_id IS 'Item UUID';

COMMENT ON COLUMN loans_renewal_count.item_hrid IS 'Item HRID';

COMMENT ON COLUMN loans_renewal_count.num_loans IS 'Count of loans associated with the item';

COMMENT ON COLUMN loans_renewal_count.num_renewals IS 'Count of renewals associated with the item';

VACUUM ANALYZE loans_renewal_count;

