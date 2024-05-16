DROP TABLE IF EXISTS instance_statistical_codes;

-- Creates a local table for instances with the id and name for the code and type.
CREATE TABLE instance_statistical_codes AS
WITH instances_statistical_codes AS (
    SELECT
        instance.id AS instance_id,
        instance.hrid AS instance_hrid,
        (statistical_code_ids.data #>> '{}')::uuid AS statistical_code_id
    FROM
        inventory_instances AS instance
        CROSS JOIN LATERAL jsonb_array_elements((data #> '{statisticalCodeIds}')::jsonb)
            AS statistical_code_ids(data)
)
SELECT
    instances_statistical_codes.instance_id,
    instances_statistical_codes.instance_hrid,
    instances_statistical_codes.statistical_code_id,
    inventory_statistical_codes.code AS statistical_code,
    inventory_statistical_codes.name AS statistical_code_name,
    inventory_statistical_code_types.id AS statistical_code_type_id,
    inventory_statistical_code_types.name AS statistical_code_type_name
FROM
    instances_statistical_codes
    LEFT JOIN inventory_statistical_codes
        ON instances_statistical_codes.statistical_code_id = inventory_statistical_codes.id::uuid
    LEFT JOIN inventory_statistical_code_types
        ON inventory_statistical_codes.statistical_code_type_id = inventory_statistical_code_types.id;

