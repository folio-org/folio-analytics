-- Create a local table for purchase order line instance.  Every po
-- line may have location ID or holding ID or both can be null, if
-- both are null then "no source' is present in pol_location_source.
-- pol_location depends on how the po is created.

DROP TABLE IF EXISTS po_instance;

CREATE TABLE po_instance AS
SELECT
    po_purchase_orders.manual_po::boolean,
    json_extract_path_text(po_lines.data, 'rush')::boolean AS rush,
    json_extract_path_text(po_lines.data, 'requester') AS requester,
    po_lines.selector AS selector,
    po_purchase_orders.po_number AS po_number,
    po_purchase_orders.id::uuid AS po_number_id,
    po_lines.po_line_number AS po_line_number,
    po_lines.id::uuid AS po_line_id,
    organization_organizations.code AS vendor_code,
    user_users.username AS created_by_username,
    po_purchase_orders.workflow_status AS po_workflow_status,
    json_extract_path_text(po_purchase_orders.data, 'approved')::boolean AS status_approved,
    json_extract_path_text(po_purchase_orders.data, 'metadata', 'createdDate')::timestamptz AS created_date,
    json_extract_path_text(ce.value::json, 'name') AS bill_to,
    json_extract_path_text(ce.value::json, 'name') AS ship_to,
    json_extract_path_text(po_lines.data, 'instanceId') AS pol_instance_id,
    inventory_instances.hrid AS pol_instance_hrid,
    json_extract_path_text(locations.data, 'holdingId') AS pol_holdings_id,
    CASE WHEN json_extract_path_text(locations.data, 'locationId') IS NOT NULL
         THEN json_extract_path_text(locations.data, 'locationId')
         ELSE ih.permanent_location_id END AS pol_location_id,
    CASE WHEN (il.name) IS NOT NULL
         THEN il.name
         ELSE il2.name END AS pol_location_name,
    CASE WHEN il.name IS NOT NULL
         THEN 'pol_location'
         WHEN il2.name IS NOT NULL
         THEN 'pol_holding'
         ELSE 'no_source' END AS pol_location_source,
    inventory_instances.title AS title,
    json_extract_path_text(po_lines.data, 'publicationDate') AS publication_date,
    json_extract_path_text(po_lines.data, 'publisher') AS publisher
FROM
    po_purchase_orders
    LEFT JOIN po_lines ON po_purchase_orders.id = json_extract_path_text(po_lines.data, 'purchaseOrderId')
    CROSS JOIN json_array_elements(json_extract_path(po_lines.data, 'locations')) AS locations (data)
    LEFT JOIN inventory_locations AS il ON json_extract_path_text(locations.data, 'locationId') = il.id
    LEFT JOIN inventory_holdings AS ih ON json_extract_path_text(locations.data, 'holdingId') = ih.id
    LEFT JOIN inventory_locations AS il2 ON ih.permanent_location_id = il2.id
    LEFT JOIN inventory_instances ON json_extract_path_text(po_lines.data, 'instanceId') = inventory_instances.id
    LEFT JOIN organization_organizations ON json_extract_path_text(po_purchase_orders.data, 'vendor') = organization_organizations.id
    LEFT JOIN configuration_entries AS ce ON json_extract_path_text(po_purchase_orders.data, 'billTo') = ce.id
    LEFT JOIN configuration_entries AS ce2 ON json_extract_path_text(po_purchase_orders.data, 'shipTo') = ce2.id
    LEFT JOIN user_users ON json_extract_path_text(po_purchase_orders.data, 'metadata', 'createdByUserId') = user_users.id
;

CREATE INDEX ON po_instance (manual_po);

CREATE INDEX ON po_instance (rush);

CREATE INDEX ON po_instance (requester);

CREATE INDEX ON po_instance (selector);

CREATE INDEX ON po_instance (po_number);

CREATE INDEX ON po_instance (po_number_id);

CREATE INDEX ON po_instance (po_line_number);

CREATE INDEX ON po_instance (po_line_id);

CREATE INDEX ON po_instance (vendor_code);

CREATE INDEX ON po_instance (created_by_username);

CREATE INDEX ON po_instance (po_workflow_status);

CREATE INDEX ON po_instance (status_approved);

CREATE INDEX ON po_instance (created_date);

CREATE INDEX ON po_instance (bill_to);

CREATE INDEX ON po_instance (ship_to);

CREATE INDEX ON po_instance (pol_instance_id);

CREATE INDEX ON po_instance (pol_instance_hrid);

CREATE INDEX ON po_instance (pol_holdings_id);

CREATE INDEX ON po_instance (pol_location_id);

CREATE INDEX ON po_instance (pol_location_name);

CREATE INDEX ON po_instance (pol_location_source);

CREATE INDEX ON po_instance (title);

CREATE INDEX ON po_instance (publication_date);

CREATE INDEX ON po_instance (publisher);


VACUUM ANALYZE po_instance;

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

COMMENT ON COLUMN po_instance.status_approved IS 'Weather purchase order is approved or not';

COMMENT ON COLUMN po_instance.created_date IS 'Date when the purchase order was created';

COMMENT ON COLUMN po_instance.bill_to IS 'Name of the bill_to location of the purchase order';

COMMENT ON COLUMN po_instance.ship_to IS 'Name of the ship_to location of the purchase order';

COMMENT ON COLUMN po_instance.pol_instance_id IS 'UUID of the instance record this purchase order line is related to';

COMMENT ON COLUMN po_instance.pol_instance_hrid IS 'A human readable number of the instance record this purchase order line is related to';

COMMENT ON COLUMN po_instance.pol_holdings_id IS 'UUID of the holdings this purchase order line is related to';

COMMENT ON COLUMN po_instance.pol_location_id IS 'UUID of the location created for this purchase order line';

COMMENT ON COLUMN po_instance.pol_location_name IS 'Name of the purchase order line location';

COMMENT ON COLUMN po_instance.pol_location_source IS 'Weather location of the material is a location or permanent location of the purchase order line in inventory';

COMMENT ON COLUMN po_instance.title IS 'Title of the material';

COMMENT ON COLUMN po_instance.publication_date IS 'Date (year) of the material''s publication';

COMMENT ON COLUMN po_instance.publisher IS 'Publisher of the material';
