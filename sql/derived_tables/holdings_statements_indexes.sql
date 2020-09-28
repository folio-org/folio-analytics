DROP TABLE IF EXISTS local.holdings_statements_indexes;

-- This table contains holdings statements for indexes with their
-- associated public/staff only notes; regular holdings statements and
-- holdings statements for supplements are in separate tables.
CREATE TABLE local.holdings_statements_indexes AS
SELECT
    holdings.id AS holdings_id,
    holdings.hrid AS holdings_hrid,
    json_extract_path_text(holdings_statements_for_indexes.data, 'statement') AS holdings_statement_indexes,
    json_extract_path_text(holdings_statements_for_indexes.data, 'note') AS holdings_statement_indexes_public_note,
    json_extract_path_text(holdings_statements_for_indexes.data, 'staffNote') AS holdings_statement_indexes_staff_note
FROM
    inventory_holdings AS holdings
    CROSS JOIN json_array_elements(json_extract_path(data, 'holdingsStatementsForIndexes')) AS holdings_statements_for_indexes(data);

CREATE INDEX ON local.holdings_statements_indexes (holdings_id);

CREATE INDEX ON local.holdings_statements_indexes (holdings_hrid);

CREATE INDEX ON local.holdings_statements_indexes (holdings_statement_indexes);

CREATE INDEX ON local.holdings_statements_indexes (holdings_statement_indexes_public_note);

CREATE INDEX ON local.holdings_statements_indexes (holdings_statement_indexes_staff_note);

VACUUM local.holdings_statements_indexes;

ANALYZE local.holdings_statements_indexes;

