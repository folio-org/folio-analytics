DROP TABLE IF EXISTS holdings_statements_supplements;

-- This table contains holdings statements for supplements with their
-- associated public/staff only notes; regular holdings statements and
-- holdings statements for indexes are in separate tables. Here note is a public note.
CREATE TABLE holdings_statements_supplements AS
SELECT
    holdings.id AS holdings_id,
    holdings.hrid AS holdings_hrid,
    holdings_statements_for_supplements.data->>'statement' AS "statement",
    holdings_statements_for_supplements.data->>'note' AS public_note,
    holdings_statements_for_supplements.data->>'staffNote' AS staff_note
FROM
    inventory_holdings AS holdings
    CROSS JOIN jsonb_array_elements((data->'holdingsStatementsForSupplements')::jsonb) AS holdings_statements_for_supplements(data);

