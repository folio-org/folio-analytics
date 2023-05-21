DROP TABLE IF EXISTS inventory_modes_of_issuance;

CREATE TABLE inventory_modes_of_issuance AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_extract_path_text(jsonb, 'source')::varchar(65535) AS source,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_inventory.mode_of_issuance;

ALTER TABLE inventory_modes_of_issuance ADD PRIMARY KEY (id);

CREATE INDEX ON inventory_modes_of_issuance (name);

CREATE INDEX ON inventory_modes_of_issuance (source);

