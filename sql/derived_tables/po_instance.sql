DROP TABLE IF EXISTS po_instance;

CREATE TABLE po_instance AS
SELECT
    json_extract_path_text(po_purchase_orders.data, 'poNumber') AS po_number,
    organization_organizations.code AS vendor_code,
    user_users.username AS created_by,
    po_lines.po_line_number,
    po_purchase_orders.workflow_status AS po_wf_status,
    json_extract_path_text(po_purchase_orders.data, 'approved')::boolean AS status_approved,
    json_extract_path_text(po_purchase_orders.data, 'metadata', 'createdDate') AS created_date,  
    json_extract_path_text(configuration_entries.value::json, 'name') AS created_location,
    json_extract_path_text(po_lines.data, 'instanceId') AS pol_instance_id,
    inventory_instances.hrid AS pol_instance_hrid,
    inventory_instances.title AS title,
    json_extract_path_text(po_lines.data, 'publicationDate') AS publication_date,
    json_extract_path_text(po_lines.data, 'publisher') AS publisher,
    json_extract_path_text(po_lines.data, 'requester') AS requester,
    json_extract_path_text(po_lines.data, 'rush')::boolean AS rush,
    json_extract_path_text(po_lines.data, 'selector') AS selector,
    json_extract_path_text(locations.data, 'locationId') AS pol_location_id,
    inventory_locations.name AS pol_location_name
FROM
    po_purchase_orders
    LEFT JOIN po_lines ON po_purchase_orders.id = json_extract_path_text(po_lines.data, 'purchaseOrderId')
    CROSS JOIN json_array_elements(json_extract_path(po_lines.data, 'locations')) AS locations (data)
    LEFT JOIN inventory_locations ON json_extract_path_text(locations.data, 'locationId') = inventory_locations.id
    LEFT JOIN inventory_instances ON json_extract_path_text(po_lines.data, 'instanceId') = inventory_instances.id
    LEFT JOIN organization_organizations ON json_extract_path_text(po_purchase_orders.data, 'vendor') = organization_organizations.id
    LEFT JOIN configuration_entries ON json_extract_path_text(po_purchase_orders.data, 'billTo') = configuration_entries.id
    LEFT JOIN user_users ON json_extract_path_text(po_purchase_orders.data, 'metadata', 'createdByUserId') = user_users.id;

CREATE INDEX ON po_instance (po_number);

CREATE INDEX ON po_instance (vendor_code);

CREATE INDEX ON po_instance (status_approved);

CREATE INDEX ON po_instance (created_date);

CREATE INDEX ON po_instance (created_by);

CREATE INDEX ON po_instance (created_location);

CREATE INDEX ON po_instance (pol_instance_id);

CREATE INDEX ON po_instance (title);

CREATE INDEX ON po_instance (publication_date);

CREATE INDEX ON po_instance (publisher);

CREATE INDEX ON po_instance (requester);

CREATE INDEX ON po_instance (rush);

CREATE INDEX ON po_instance (selector);

CREATE INDEX ON po_instance (pol_location_id);

CREATE INDEX ON po_instance (pol_location_name);

VACUUM ANALYZE  po_instance;
