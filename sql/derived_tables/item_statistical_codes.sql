DROP TABLE IF EXISTS item_statistical_codes;

-- Create a local table for item statistics with the id and name of the code and type.
CREATE TABLE item_statistical_codes AS
WITH items_statistical_codes AS (
    SELECT
        item.id AS item_id,
        item.hrid AS item_hrid,
	(statistical_code_ids.data #>> '{}')::uuid AS statistical_code_id
    FROM
        inventory_items AS item
	CROSS JOIN jsonb_array_elements((data #> '{statisticalCodeIds}')::jsonb) AS statistical_code_ids(data)
)
SELECT
    items_statistical_codes.item_id,
    items_statistical_codes.item_hrid,
    items_statistical_codes.statistical_code_id,
    inventory_statistical_codes.code AS statistical_code,
    inventory_statistical_codes.name AS statistical_code_name,
    inventory_statistical_code_types.id AS statistical_code_type_id,
    inventory_statistical_code_types.name AS statistical_code_type_name
FROM
    items_statistical_codes
    LEFT JOIN inventory_statistical_codes ON items_statistical_codes.statistical_code_id = inventory_statistical_codes.id::uuid
    LEFT JOIN inventory_statistical_code_types
        ON inventory_statistical_codes.statistical_code_type_id = inventory_statistical_code_types.id;

