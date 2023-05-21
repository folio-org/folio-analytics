DROP TABLE IF EXISTS inventory_holdings_sources;

CREATE TABLE inventory_holdings_sources AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_extract_path_text(jsonb, 'source')::varchar(65535) AS source,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_inventory.holdings_records_source;

ALTER TABLE inventory_holdings_sources ADD PRIMARY KEY (id);

CREATE INDEX ON inventory_holdings_sources (name);

CREATE INDEX ON inventory_holdings_sources (source);

