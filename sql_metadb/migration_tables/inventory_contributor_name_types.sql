DROP TABLE IF EXISTS inventory_contributor_name_types;

CREATE TABLE inventory_contributor_name_types AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_extract_path_text(jsonb, 'ordering')::varchar(65535) AS ordering,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_inventory.contributor_name_type;

