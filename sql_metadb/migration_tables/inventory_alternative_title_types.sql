DROP TABLE IF EXISTS inventory_alternative_title_types;

CREATE TABLE inventory_alternative_title_types AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_extract_path_text(jsonb, 'source')::varchar(65535) AS source,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_inventory.alternative_title_type;

