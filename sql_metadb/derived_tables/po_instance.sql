--metadb:table po_instance

DROP TABLE IF EXISTS po_instance;

CREATE TABLE po_instance AS
SELECT DISTINCT 
    purchase_order__t.manual_po::BOOLEAN AS manual_po,
    po_line__t.rush AS rush,
    purchase_order__t.order_type AS order_type,
    po_line__t.requester AS requester,
    po_line__t.selector AS selector,
    purchase_order__t.po_number AS po_number,
    po_line.purchaseorderid AS po_number_id,
    jsonb_extract_path_text(po_line.JSONB,'poLineNumber') AS po_line_number,
    po_line.id AS po_line_id,
    organizations__t.code AS vendor_code, 
    users__t.username AS created_by_username,
    purchase_order__t.workflow_status AS po_workflow_status,
    purchase_order__t.approved::BOOLEAN AS status_approved,
    jsonb_extract_path_text(purchase_order.jsonb,'metadata','createdDate')::timestamptz AS created_date,  
    jsonb_extract_path_text(cdt.value::jsonb,'name') AS bill_to,
    jsonb_extract_path_text(cdt2.value::jsonb,'name') AS ship_to,
    po_line__t.instance_id AS pol_instance_id,
    instance__t.hrid AS pol_instance_hrid,
    jsonb_extract_path_text(locations.jsonb,'holdingId')::uuid AS pol_holding_id,
    jsonb_extract_path_text(locations.jsonb,'locationId')::uuid AS pol_location_id,     
    COALESCE (location__t.name, location__t2.name,'deleted_holding') AS pol_location_name,
    CASE 
        WHEN (location__t.name IS NULL AND location__t2.name IS NULL) THEN 'no sourse'
        WHEN (location__t.name IS NULL AND location__t2.name IS NOT NULL) THEN 'pol_holding'
        WHEN (location__t.name IS NOT NULL AND location__t2.name IS NULL) THEN 'pol_location'
        ELSE 'x' END AS pol_location_source,    
    po_line__t.title_or_package AS title,
    po_line__t.publication_date AS publication_date,
    po_line__t.publisher AS publisher,
    jsonb_extract_path_text(po_line.jsonb,'paymentStatus') AS payment_status,
    jsonb_extract_path_text(po_line.jsonb,'receiptStatus') AS receipt_status,
    users__t2.username as po_updated_by, 
    jsonb_extract_path_text(purchase_order.jsonb, 'metadata', 'updatedDate')::TIMESTAMPTZ AS po_updated_date, 
    location__t2.name AS holdings_location_name
    FROM folio_orders.po_line 
         CROSS JOIN LATERAL jsonb_array_elements((po_line.jsonb #> '{locations}')::jsonb) AS locations (data)
    LEFT JOIN folio_orders.po_line__t  ON po_line.id = po_line__t.id
    LEFT JOIN folio_inventory.instance__t ON (jsonb_extract_path_text(po_line.jsonb,'instanceId'))::UUID = instance__t.id
    LEFT JOIN folio_inventory.location__t ON (jsonb_extract_path_text(locations.jsonb,'locationId'))::uuid = location__t.id
    LEFT JOIN folio_orders.purchase_order__t ON po_line.purchaseorderid = purchase_order__t.id 
    LEFT JOIN folio_inventory.holdings_record__t ON jsonb_extract_path_text(locations.jsonb, 'holdingId')::uuid = holdings_record__t.id
    LEFT JOIN folio_inventory.location__t AS location__t2 ON holdings_record__t.permanent_location_id = location__t2.id 
    LEFT JOIN folio_organizations.organizations__t ON purchase_order__t.vendor = organizations__t.id
    LEFT JOIN folio_orders.purchase_order ON purchase_order__t.id = purchase_order.id
    LEFT JOIN folio_configuration.config_data__t AS cdt ON jsonb_extract_path_text(purchase_order.jsonb,'billTo')::uuid = cdt.id
    LEFT JOIN folio_configuration.config_data__t AS cdt2 ON jsonb_extract_path_text(purchase_order.jsonb,'shipTo')::uuid = cdt2.id
    LEFT JOIN folio_users.users__t ON jsonb_extract_path_text(purchase_order.jsonb,'metadata','createdByUserId')::uuid = users__t.id
    LEFT JOIN folio_users.users__t AS users__t2 ON jsonb_extract_path_text(purchase_order.jsonb,'metadata','updatedByUserId')::uuid = users__t2.id
    ;
    
COMMENT ON COLUMN po_instance.manual_po IS 'If true, order cannot be sent automatically, e.g. via EDI';

COMMENT ON COLUMN po_instance.rush IS 'Whether or not this is a rush order';

COMMENT ON COLUMN purchase_order__t.order_type IS 'Type of purchase order';

COMMENT ON COLUMN po_instance.requester IS 'Who requested this material and needs to be notified on arrival';

COMMENT ON COLUMN po_instance.selector IS 'Who selected this material';

COMMENT ON COLUMN po_instance.po_number IS 'A human readable number assigned to PO';

COMMENT ON COLUMN po_instance.po_number_id IS 'UUID identifying this PO';

COMMENT ON COLUMN po_instance.po_line_number IS 'A human readable number assigned to PO line';

COMMENT ON COLUMN po_instance.po_line_id IS 'UUID identifying this purchase order line';

COMMENT ON COLUMN po_instance.vendor_code IS 'The code of the vendor';

COMMENT ON COLUMN po_instance.created_by_username IS 'Username of the user who created the record (when available)';

COMMENT ON COLUMN po_instance.po_workflow_status IS 'Workflow status of purchase order';

COMMENT ON COLUMN po_instance.status_approved IS 'Wether purchase order is approved or not';

COMMENT ON COLUMN po_instance.created_date IS 'Date when the purchase order was created';

COMMENT ON COLUMN po_instance.bill_to IS 'Name of the bill_to location of the purchase order';

COMMENT ON COLUMN po_instance.ship_to IS 'Name of the ship_to location of the purchase order';

COMMENT ON COLUMN po_instance.pol_instance_id IS 'UUID of the instance record this purchase order line is related to';

COMMENT ON COLUMN po_instance.pol_instance_hrid IS 'A human readable number of the instance record this purchase order line is related to';

COMMENT ON COLUMN po_instance.pol_holding_id IS 'UUID of the holdings this purchase order line is related to';

COMMENT ON COLUMN po_instance.pol_location_id IS 'UUID of the location created for this purcase order line';

COMMENT ON COLUMN po_instance.pol_location_name IS 'Name of the purchase order line location';

COMMENT ON COLUMN po_instance.pol_location_source IS 'Wether location is a holdings location or permanent location of the purchase order line';

COMMENT ON COLUMN po_instance.title IS 'Title of the material';

COMMENT ON COLUMN po_instance.publication_date IS 'Date (year) of the material''s publication';

COMMENT ON COLUMN po_instance.publisher IS 'Publisher of the material';

COMMENT ON COLUMN payment_status IS 'The payment status of the order';

COMMENT ON COLUMN receipt_status IS 'Teh recete status of the order';

COMMENT ON COLUMN po_updated_by IS 'Name of the user who updated the order';

COMMENT ON COLUMN po_updated_date IS 'Date when the order was last updated';

COMMENT ON COLUMN holdings_location_name IS 'Location name of the holding on purchase order line';
