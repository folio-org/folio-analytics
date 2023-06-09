DROP TABLE IF EXISTS holdings_statements_indexes;

-- This table contains holdings statements for indexes with their
-- associated public/staff only notes; regular holdings statements and
-- holdings statements for supplements are in separate tables. Here note is a public note.
CREATE TABLE holdings_statements_indexes AS
SELECT
    holdings.id AS holdings_id,
    holdings.hrid AS holdings_hrid,
    holdings_statements_for_indexes.data->>'statement' AS "statement",
    holdings_statements_for_indexes.data->>'note' AS public_note,
    holdings_statements_for_indexes.data->>'staffNote' AS staff_note
FROM
    inventory_holdings AS holdings
    CROSS JOIN jsonb_array_elements((data->'holdingsStatementsForIndexes')::jsonb) AS holdings_statements_for_indexes(data);

