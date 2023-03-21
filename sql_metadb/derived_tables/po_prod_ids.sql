"--metadb:table po_prod_ids

--This table pulls product id and identifies type of product id from a Purchase order line.

DROP TABLE IF EXISTS po_prod_ids;

CREATE TABLE po_prod_ids AS
WITH po_prod_id AS (
SELECT
    pol.id AS pol_id,
    jsonb_extract_path_text(pol.jsonb, 'poLineNumber') AS pol_number,
    jsonb_extract_path_text(details.jsonb, 'productId') AS product_id,
    jsonb_extract_path_text(details.jsonb, 'productIdType')::uuid AS product_id_type
FROM folio_orders.po_line AS pol
CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(jsonb, 'details', 'productIds'))
        WITH ORDINALITY AS details (jsonb)
)
SELECT 
    ppi.pol_id AS pol_id,
    ppi.pol_number AS pol_number,
    ppi.product_id,
    itt."name" AS product_id_type    
    FROM po_prod_id AS ppi
    LEFT JOIN folio_inventory.identifier_type__t itt ON ppi.product_id_type = itt.id
;

CREATE INDEX ON po_prod_ids (pol_id);

CREATE INDEX ON po_prod_ids (pol_number);

CREATE INDEX ON po_prod_ids (product_id);

CREATE INDEX ON po_prod_ids (product_id_type);


VACUUM ANALYZE po_prod_ids;

COMMENT ON COLUMN po_prod_ids.pol_id IS 'UUID identifying this purchase order line';

COMMENT ON COLUMN po_prod_ids.pol_number IS 'A human readable ID assigned to this purchase order line';

COMMENT ON COLUMN po_prod_ids.product_id IS 'The actual product identifier';

COMMENT ON COLUMN po_prod_ids.product_id_type IS 'The type of product identifier';
