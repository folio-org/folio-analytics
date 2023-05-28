DROP TABLE IF EXISTS holdings_statements;

-- This table contains holdings statements with their associated
-- public/staff only notes; holdings statements for supplements and
-- indexes are in separate tables. Here note is a public note.
CREATE TABLE holdings_statements AS
SELECT
    holdings.id AS holdings_id,
    holdings.hrid AS holdings_hrid,
    json_extract_path_text(holdings_statement.data, 'statement') AS "statement",
    json_extract_path_text(holdings_statement.data, 'note') AS public_note,
    json_extract_path_text(holdings_statement.data, 'staffNote') AS staff_note
FROM
    inventory_holdings AS holdings
    CROSS JOIN json_array_elements(json_extract_path(data, 'holdingsStatements')) AS holdings_statement(data);

