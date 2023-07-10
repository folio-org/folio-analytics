DROP TABLE IF EXISTS inventory_libraries;

CREATE TABLE inventory_libraries AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'campusId')::varchar(36) AS campus_id,
    jsonb_extract_path_text(jsonb, 'code')::varchar(65535) AS code,
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_inventory.loclibrary;

