DROP TABLE IF EXISTS inventory_statistical_codes;

CREATE TABLE inventory_statistical_codes AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'code')::varchar(65535) AS code,
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_extract_path_text(jsonb, 'source')::varchar(65535) AS source,
    jsonb_extract_path_text(jsonb, 'statisticalCodeTypeId')::varchar(36) AS statistical_code_type_id,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_inventory.statistical_code;

