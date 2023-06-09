DROP TABLE IF EXISTS po_prod_ids;

CREATE TABLE po_prod_ids AS
WITH po_prod_id AS (
    SELECT
        pl.id AS pol_id,
        pl.po_line_number AS pol_number,
        product_ids.data->>'productId' AS prod_id,
        product_ids.data->>'productIdType' AS prod_id_type
    FROM
        po_lines AS pl
        CROSS JOIN pl.data->'details' AS details (data)
        CROSS JOIN jsonb_array_elements((details.data->'productIds')::jsonb) AS product_ids (data))
SELECT
    pol_number,
    prod_id,
    inventory_identifier_types.name AS prod_id_type_name
FROM
    po_prod_id
    LEFT JOIN po_purchase_orders AS ppo ON po_prod_id.pol_id = ppo.id
    LEFT JOIN inventory_identifier_types ON po_prod_id.prod_id_type = inventory_identifier_types.id;

