DROP TABLE IF EXISTS local.holdings_statements_supplements;

-- This table contains holdings statements for supplements with their
-- associated public/staff only notes; regular holdings statements and
-- holdings statements for indexes are in separate tables.
CREATE TABLE local.holdings_statements_supplements AS
SELECT
    holdings.id AS holdings_id,
    holdings.hrid AS holdings_hrid,
    json_extract_path_text(holdings_statements_for_supplements.data, 'statement') AS holdings_statement_supplements,
    json_extract_path_text(holdings_statements_for_supplements.data, 'note') AS holdings_statement_supplements_public_note,
    json_extract_path_text(holdings_statements_for_supplements.data, 'staffNote') AS holdings_statement_supplements_staff_note
FROM
    inventory_holdings AS holdings
    CROSS JOIN json_array_elements(json_extract_path(data, 'holdingsStatementsForSupplements')) AS holdings_statements_for_supplements(data);

CREATE INDEX ON local.holdings_statements_supplements (holdings_id);

CREATE INDEX ON local.holdings_statements_supplements (holdings_hrid);

CREATE INDEX ON local.holdings_statements_supplements (holdings_statement_supplements);

CREATE INDEX ON local.holdings_statements_supplements (holdings_statement_supplements_public_note);

CREATE INDEX ON local.holdings_statements_supplements (holdings_statement_supplements_staff_note);

VACUUM local.holdings_statements_supplements;

ANALYZE local.holdings_statements_supplements;

