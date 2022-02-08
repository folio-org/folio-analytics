DROP TABLE IF EXISTS inventory_statistical_code_types;

CREATE TABLE inventory_statistical_code_types AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_extract_path_text(jsonb, 'source')::varchar(65535) AS source,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_inventory.statistical_code_type;

ALTER TABLE inventory_statistical_code_types ADD PRIMARY KEY (id);

CREATE INDEX ON inventory_statistical_code_types (name);

CREATE INDEX ON inventory_statistical_code_types (source);

VACUUM ANALYZE inventory_statistical_code_types;
