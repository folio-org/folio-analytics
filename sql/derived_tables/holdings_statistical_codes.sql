DROP TABLE IF EXISTS holdings_statistical_codes;

-- Create a local holdings table with the id and name for the code and type.
CREATE TABLE holdings_statistical_codes AS
WITH holdings_statistical_codes AS (
    SELECT
        holdings.id AS holdings_id,
        holdings.hrid AS holdings_hrid,
        (statistical_code_ids.data #>> '{}')::uuid AS statistical_code_id
    FROM
        inventory_holdings AS holdings
        CROSS JOIN jsonb_array_elements((data #> '{statisticalCodeIds}')::jsonb) AS statistical_code_ids (data)
)
SELECT
    holdings_statistical_codes.holdings_id,
    holdings_statistical_codes.holdings_hrid,
    holdings_statistical_codes.statistical_code_id,
    inventory_statistical_codes.code AS statistical_code,
    inventory_statistical_codes.name AS statistical_code_name,
    inventory_statistical_code_types.id AS statistical_code_type_id,
    inventory_statistical_code_types.name AS statistical_code_type_name
FROM
    holdings_statistical_codes
    LEFT JOIN inventory_statistical_codes
        ON holdings_statistical_codes.statistical_code_id = inventory_statistical_codes.id::uuid
    LEFT JOIN inventory_statistical_code_types
        ON inventory_statistical_codes.statistical_code_type_id = inventory_statistical_code_types.id;
