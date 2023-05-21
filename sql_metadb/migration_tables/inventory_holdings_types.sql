DROP TABLE IF EXISTS inventory_holdings_types;

CREATE TABLE inventory_holdings_types AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_extract_path_text(jsonb, 'source')::varchar(65535) AS source,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_inventory.holdings_type;

ALTER TABLE inventory_holdings_types ADD PRIMARY KEY (id);

CREATE INDEX ON inventory_holdings_types (name);

CREATE INDEX ON inventory_holdings_types (source);

