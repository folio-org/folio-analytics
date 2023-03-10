--metadb:table_ <po_instance>

-- Create a local_core table for purchase order line instance. Every po line may have location ID or holding ID or both can be 'null', if both are 'null'
--then "no source' is present in pol_location_source.
--Pol_location depends on how the po is created.

DROP TABLE IF EXISTS po_instance;

CREATE TABLE po_instance AS
SELECT
    pot.manual_po,
    poltt.rush::boolean AS rush,
    poltt.requester AS requester,
    poltt.selector AS selector,
    pot.po_number AS po_number,
    pot.id AS po_number_id,
    poltt.po_line_number AS po_line_number,
    poltt.id AS po_line_id,
    ot.code AS vendor_code, ---vendor id CONNECT TO vendor name
    ut.username AS created_by_username,
    pot.workflow_status AS po_workflow_status,
    pot.approved::boolean AS status_approved,
    jsonb_extract_path_text(po.jsonb, 'metadata', 'createdDate')::timestamptz AS created_date,  
    pot.bill_to AS bill_to,
    pot.ship_to AS ship_to,
    poltt.instance_id AS pol_instance_id,
    it.hrid AS pol_instance_hrid,
    jsonb_extract_path_text(pol.jsonb, 'holdingId')::uuid AS pol_holding_id,
    CASE WHEN jsonb_extract_path_text(pol.jsonb, 'locations', 'locationId') IS NOT NULL
         THEN jsonb_extract_path_text(pol.jsonb, 'locations', 'locationId')::uuid 
         ELSE ih.permanentlocationid END AS pol_location_id,
    CASE WHEN (lot.name) IS NOT NULL
         THEN lot.name
         ELSE lot2.name END AS pol_location_name,
    CASE WHEN lot.name IS NOT NULL
         THEN 'pol_location'
         WHEN lot2.name IS NOT NULL
         THEN 'pol_holding'
         ELSE 'no_source' END AS pol_location_source,
    it.title AS title,
    poltt.publication_date AS publication_date,
    poltt.publisher AS publisher
    FROM
    folio_orders.purchase_order__t AS pot
    LEFT JOIN folio_orders.po_line__t AS poltt ON pot.id = poltt.purchase_order_id
    LEFT JOIN folio_orders.po_line AS pol ON pot.id=pol.purchaseorderid 
    LEFT JOIN folio_inventory.location AS il ON jsonb_extract_path_text(pol.jsonb, 'locations', 'locationId')::uuid= il.id::uuid
    LEFT JOIN folio_inventory.location__t AS lot ON il.id=lot.id
    LEFT JOIN folio_inventory.holdings_record AS ih ON jsonb_extract_path_text(pol.jsonb, 'locations', 'holdingId') ::uuid= ih.id
    LEFT JOIN folio_inventory.location__t AS lot2 ON ih.permanentlocationid = lot2.id 
    LEFT JOIN folio_inventory.instance__t AS it ON poltt.instance_id = it.id
    LEFT JOIN folio_organizations.organizations__t AS ot ON pot.vendor = ot.id
    LEFT JOIN folio_orders.purchase_order AS po ON pot.id=po.id
    LEFT JOIN folio_configuration.config_data cc ON jsonb_extract_path_text(po.jsonb, 'billTo')::uuid= cc.id
    LEFT JOIN folio_configuration.config_data cc2 ON jsonb_extract_path_text(po.jsonb, 'billTo')::uuid= cc2.id
    LEFT JOIN folio_users.users__t AS ut ON jsonb_extract_path_text(po.jsonb, 'metadata', 'createdByUserId') ::uuid= ut.id
;
CREATE INDEX ON po_instance (po_number);

CREATE INDEX ON po_instance (po_line_number);

CREATE INDEX ON po_instance (vendor_code);

CREATE INDEX ON po_instance (created_by_username);

CREATE INDEX ON po_instance (po_workflow_status);

CREATE INDEX ON po_instance (status_approved);

CREATE INDEX ON po_instance (created_date);

CREATE INDEX ON po_instance (bill_to);

CREATE INDEX ON po_instance (ship_to);

CREATE INDEX ON po_instance (pol_instance_id);

CREATE INDEX ON po_instance (pol_instance_hrid);

CREATE INDEX ON po_instance (pol_location_id);

CREATE INDEX ON po_instance (pol_location_name);

CREATE INDEX ON po_instance (pol_location_source);

CREATE INDEX ON po_instance (title);

CREATE INDEX ON po_instance (publication_date);

CREATE INDEX ON po_instance (publisher);

CREATE INDEX ON po_instance (requester);

CREATE INDEX ON po_instance (rush);

CREATE INDEX ON po_instance (selector);


--VACUUM ANALYZE  po_instance;

COMMENT ON COLUMN po_instance.manual_po IS 'If true, order cannot be sent automatically, e.g. via EDI';

COMMENT ON COLUMN po_instance.rush IS 'Whether or not this is a rush order';

COMMENT ON COLUMN po_instance.requester IS 'Who requested this material and needs to be notified on arrival';

COMMENT ON COLUMN po_instance.selector IS 'Who selected this material';

COMMENT ON COLUMN po_instance.po_number IS 'A human readable number assigned to PO';

COMMENT ON COLUMN po_instance.po_number_id IS 'UUID identifying this PO';

COMMENT ON COLUMN po_instance.po_line_number IS 'A human readable number assigned to PO line';

COMMENT ON COLUMN po_instance.po_line_id IS 'UUID identifying this purchase order line';

COMMENT ON COLUMN po_instance.vendor_code IS 'The code of the vendor';

COMMENT ON COLUMN po_instance.created_by_username IS 'Username of the user who created the record (when available)';

COMMENT ON COLUMN po_instance.po_workflow_status IS 'Workflow status of purchase order';

COMMENT ON COLUMN po_instance.status_approved IS 'Weather purchase order is approved or not';

COMMENT ON COLUMN po_instance.created_date IS 'Date when the purchase order was created';

COMMENT ON COLUMN po_instance.bill_to IS 'Name of the bill_to location of the purchase order';

COMMENT ON COLUMN po_instance.ship_to IS 'Name of the ship_to location of the purchase order';

COMMENT ON COLUMN po_instance.pol_instance_id IS 'UUID of the instance record this purchase order line is related to';

COMMENT ON COLUMN po_instance.pol_instance_hrid IS 'A human readable number of the instance record this purchase order line is related to';

COMMENT ON COLUMN po_instance.pol_holding_id IS 'UUID of the holdings this purchase order line is related to';

COMMENT ON COLUMN po_instance.pol_location_id IS 'UUID of the location created for this purcase order line';

COMMENT ON COLUMN po_instance.pol_location_name IS 'Name od the purchase order line location';

COMMENT ON COLUMN po_instance.pol_location_source IS 'Weather location is a holdings location or permanent location of the purchase order line';

COMMENT ON COLUMN po_instance.title IS 'Title of the material';

COMMENT ON COLUMN po_instance.publication_date IS 'Date (year) of the material''s publication';

COMMENT ON COLUMN po_instance.publisher IS 'Publisher of the material';

