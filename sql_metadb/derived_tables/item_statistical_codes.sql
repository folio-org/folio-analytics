--metadb:table item_statistical_codes

-- Create a local table for item statistics with the id and name of
-- the code and type.

DROP TABLE IF EXISTS item_statistical_codes;

CREATE TABLE item_statistical_codes AS
WITH items_statistical_codes AS (
    SELECT
        item.id AS item_id,
        i.hrid AS item_hrid,
        statistical_code_ids.data #>> '{}' AS statistical_code_id
    FROM
        folio_inventory.item
        CROSS JOIN jsonb_array_elements(jsonb_extract_path(jsonb, 'statisticalCodeIds')) AS statistical_code_ids(data)
        LEFT JOIN folio_inventory.item__t AS i ON item.id = i.id
)
SELECT
    items_statistical_codes.item_id,
    items_statistical_codes.item_hrid,
    items_statistical_codes.statistical_code_id::uuid,
    sc.code AS statistical_code,
    sc.name AS statistical_code_name,
    sc.statistical_code_type_id::uuid,
    sct.name AS statistical_code_type_name
FROM
    items_statistical_codes
    LEFT JOIN folio_inventory.statistical_code__t AS sc ON items_statistical_codes.statistical_code_id::uuid = sc.id
    LEFT JOIN folio_inventory.statistical_code_type__t AS sct ON sc.statistical_code_type_id::uuid = sct.id;

CREATE INDEX ON item_statistical_codes (item_id);

CREATE INDEX ON item_statistical_codes (item_hrid);

CREATE INDEX ON item_statistical_codes (statistical_code_id);

CREATE INDEX ON item_statistical_codes (statistical_code);

CREATE INDEX ON item_statistical_codes (statistical_code_name);

CREATE INDEX ON item_statistical_codes (statistical_code_type_id);

CREATE INDEX ON item_statistical_codes (statistical_code_type_name);

VACUUM ANALYZE item_statistical_codes;
