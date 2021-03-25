CREATE TABLE AS folio_reporting.po_prod_ids
WITH po_prod_id AS (
SELECT
    pl.id AS pol_id,
    pl.po_line_number AS pol_number,
    --details.DATA,
    --product_ids.DATA,
    json_extract_path_text(product_ids.DATA, 'productId') AS prod_id,
    json_extract_path_text(product_ids.DATA, 'productIdType') AS prod_id_type
FROM
    po_lines pl
    CROSS JOIN json_extract_path(pl.data, 'details') AS details(data)
    CROSS JOIN json_array_elements(json_extract_path(details.data, 'productIds')) 
    AS product_ids(DATA))
SELECT 
    pol_number,
    prod_id,
    inventory_identifier_types.name AS prod_id_type_name
FROM po_prod_id
LEFT JOIN po_purchase_orders ppo ON 
              po_prod_id.pol_id = ppo.id
LEFT JOIN inventory_identifier_types ON
      po_prod_id.prod_id_type = inventory_identifier_types.id;
      
CREATE INDEX ON folio_reporting.po_prod_ids (pol_number);
CREATE INDEX ON folio_reporting.po_prod_ids (prod_id);
CREATE INDEX ON folio_reporting.po_prod_ids (prod_id_type_name);
