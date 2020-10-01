DROP TABLE IF EXISTS local.holdings_statements;

-- This table contains holdings statements with their associated
-- public/staff only notes; holdings statements for supplements and
-- indexes are in separate tables.
CREATE TABLE local.holdings_statements AS
SELECT
    holdings.id AS holdings_id,
    holdings.hrid AS holdings_hrid,
    json_extract_path_text(holdings_statement.data, 'statement') AS holdings_statement,
    json_extract_path_text(holdings_statement.data, 'note') AS holdings_statement_public_note,
    json_extract_path_text(holdings_statement.data, 'staffNote') AS holdings_statement_staff_note
FROM
    inventory_holdings AS holdings
    CROSS JOIN json_array_elements(json_extract_path(data, 'holdingsStatements')) AS holdings_statement(data);

CREATE INDEX ON local.holdings_statements (holdings_id);

CREATE INDEX ON local.holdings_statements (holdings_hrid);

CREATE INDEX ON local.holdings_statements (holdings_statement);

CREATE INDEX ON local.holdings_statements (holdings_statement_public_note);

CREATE INDEX ON local.holdings_statements (holdings_statement_staff_note);

