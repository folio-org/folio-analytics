--metadb:table holdings_statements_indexes

-- This table contains holdings statements for indexes with their
-- associated public/staff only notes; regular holdings statements and
-- holdings statements for supplements are in separate tables. Here note is a public note.

DROP TABLE IF EXISTS holdings_statements_indexes;

CREATE TABLE holdings_statements_indexes AS
WITH holdings AS (
    SELECT
        h.instanceid AS instance_id,
        h.id AS holdings_id,
        jsonb_extract_path_text(h.jsonb, 'hrid') AS holdings_hrid,
        jsonb_extract_path_text(hs.jsonb, 'statement') AS holdings_statement,
        jsonb_extract_path_text(hs.jsonb, 'note') AS public_note,
        jsonb_extract_path_text(hs.jsonb, 'staffNote') AS staff_note,
        hs.ordinality AS statement_ordinality
    FROM
        folio_inventory.holdings_record AS h
        CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(h.jsonb, 'holdingsStatementsForIndexes')) WITH ORDINALITY AS hs (jsonb)
)
SELECT
    hs.instance_id,
    jsonb_extract_path_text(i.jsonb, 'hrid') AS instance_hrid,
    hs.holdings_id,
    hs.holdings_hrid,
    hs.holdings_statement,
    hs.public_note,
    hs.staff_note,
    hs.statement_ordinality
FROM
    holdings AS hs
    LEFT JOIN folio_inventory.instance AS i ON hs.instance_id = i.id;


