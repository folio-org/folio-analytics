-- Create a local table for purchase order line instance.  Every po
-- line may have location ID or holding ID or both can be null, if
-- both are null then "no source' is present in pol_location_source.
-- pol_location depends on how the po is created.

DROP TABLE IF EXISTS po_instance;

CREATE TABLE po_instance AS
SELECT
    po_purchase_orders.manual_po::boolean,
    (po_lines.data #>> '{rush}')::boolean AS rush,
    po_lines.data #>> '{requester}' AS requester,
    po_lines.selector AS selector,
    po_purchase_orders.po_number AS po_number,
    po_purchase_orders.id::uuid AS po_number_id,
    po_lines.po_line_number AS po_line_number,
    po_lines.id::uuid AS po_line_id,
    organization_organizations.code AS vendor_code,
    user_users.username AS created_by_username,
    po_purchase_orders.workflow_status AS po_workflow_status,
    po_purchase_orders.approved AS status_approved,
    po_purchase_orders.metadata__created_date AS created_date,
    ce.value::json #>> '{name}' AS bill_to,
    ce.value::json #>> '{name}' AS ship_to,
    (po_lines.data #>> '{instanceId}')::uuid AS pol_instance_id,
    inventory_instances.hrid AS pol_instance_hrid,
    locations.pol_location_id,
    locations.pol_location_name,
    locations.pol_location_source,
    inventory_instances.title AS title,
    po_lines.data #>> '{publicationDate}' AS publication_date,
    po_lines.data #>> '{publisher}' AS publisher
FROM
    po_purchase_orders
    LEFT JOIN po_lines ON po_purchase_orders.id::uuid = (po_lines.data #>> '{purchaseOrderId}')::uuid
    LEFT JOIN folio_reporting.po_lines_locations AS locations ON locations.pol_id = po_lines.id
    LEFT JOIN inventory_instances ON (po_lines.data #>> '{instanceId}')::uuid = inventory_instances.id::uuid
    LEFT JOIN organization_organizations ON (po_purchase_orders.data #>> '{vendor}')::uuid = organization_organizations.id::uuid
    LEFT JOIN configuration_entries AS ce ON (po_purchase_orders.data #>> '{billTo}')::uuid = ce.id::uuid
    LEFT JOIN configuration_entries AS ce2 ON (po_purchase_orders.data #>> '{shipTo}')::uuid = ce2.id::uuid
    LEFT JOIN user_users ON (po_purchase_orders.data #>> '{metadata,createdByUserId}')::uuid = user_users.id::uuid;

COMMENT ON COLUMN po_instance.manual_po IS 'If true, order cannot be sent automatically, e.g. via EDI';

COMMENT ON COLUMN po_instance.rush IS 'Whether or not this is a rush order';

COMMENT ON COLUMN po_instance.requester IS 'Who requested this material and need to be notified on arrival';

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

COMMENT ON COLUMN po_instance.pol_location_id IS 'UUID of the location created for this purchase order line';

COMMENT ON COLUMN po_instance.pol_location_name IS 'Name of the purchase order line location';

COMMENT ON COLUMN po_instance.pol_location_source IS 'Wether location of the material is a location or permanent location of the purchase order line in inventory';

COMMENT ON COLUMN po_instance.title IS 'Title of the material';

COMMENT ON COLUMN po_instance.publication_date IS 'Date (year) of the material''s publication';

COMMENT ON COLUMN po_instance.publisher IS 'Publisher of the material';
