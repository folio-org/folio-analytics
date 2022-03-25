DROP TABLE IF EXISTS item_statistical_codes;

-- Create a local table for item statistics with the id and name of the code and type.
CREATE TABLE item_statistical_codes AS
WITH items_statistical_codes AS (
    SELECT
        i.id AS item_id,
        it.hrid AS item_hrid,
        statistical_code_ids.data #>> '{}' AS statistical_code_id
    FROM
        folio_inventory.item AS i
        CROSS JOIN jsonb_array_elements(jsonb_extract_path(jsonb, 'statisticalCodeIds')) AS statistical_code_ids(data)
        LEFT JOIN folio_inventory.item__t AS it ON i.id = it.id
)
SELECT
    items_statistical_codes.item_id,
    items_statistical_codes.item_hrid,
    items_statistical_codes.statistical_code_id,
    sc__t.code AS statistical_code,
    sc__t.name AS statistical_code_name,
    sc__t.statistical_code_type_id,
    sct__t.name AS statistical_code_type_name
FROM
    items_statistical_codes
    LEFT JOIN folio_inventory.statistical_code__t AS sc__t ON items_statistical_codes.statistical_code_id::uuid = sc__t.id
    LEFT JOIN folio_inventory.statistical_code_type__t AS sct__t ON sc__t.statistical_code_type_id::uuid = sct__t.id
;

CREATE INDEX ON item_statistical_codes (item_id);

CREATE INDEX ON item_statistical_codes (item_hrid);

CREATE INDEX ON item_statistical_codes (statistical_code_id);

CREATE INDEX ON item_statistical_codes (statistical_code);

CREATE INDEX ON item_statistical_codes (statistical_code_name);

CREATE INDEX ON item_statistical_codes (statistical_code_type_id);

CREATE INDEX ON item_statistical_codes (statistical_code_type_name);

VACUUM ANALYZE item_statistical_codes;
