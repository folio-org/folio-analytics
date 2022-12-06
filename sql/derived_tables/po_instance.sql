-- Create a local table for purchase order line instance.  Every po
-- line may have location ID or holding ID or both can be null, if
-- both are null then "no source' is present in pol_location_source.
-- pol_location depends on how the po is created.

DROP TABLE IF EXISTS po_instance;

CREATE TABLE po_instance AS
SELECT
    json_extract_path_text(po_purchase_orders.data, 'poNumber') AS po_number,
    po_lines.po_line_number AS po_line_number,
    organization_organizations.code AS vendor_code,
    user_users.username AS created_by,
    po_purchase_orders.workflow_status AS po_workflow_status,
    json_extract_path_text(po_purchase_orders.data, 'approved')::boolean AS status_approved,
    json_extract_path_text(po_purchase_orders.data, 'metadata', 'createdDate')::timestamptz AS created_date,
    json_extract_path_text(configuration_entries.value::json, 'name') AS created_location,
    json_extract_path_text(po_lines.data, 'instanceId') AS pol_instance_id,
    inventory_instances.hrid AS pol_instance_hrid,
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
    json_extract_path_text(po_lines.data, 'publisher') AS publisher,
    json_extract_path_text(po_lines.data, 'requester') AS requester,
    json_extract_path_text(po_lines.data, 'rush')::boolean AS rush,
    json_extract_path_text(po_lines.data, 'selector') AS selector
FROM
    po_purchase_orders
    LEFT JOIN po_lines ON po_purchase_orders.id = json_extract_path_text(po_lines.data, 'purchaseOrderId')
    CROSS JOIN json_array_elements(json_extract_path(po_lines.data, 'locations')) AS locations (data)
    LEFT JOIN inventory_locations AS il ON json_extract_path_text(locations.data, 'locationId') = il.id
    LEFT JOIN inventory_holdings AS ih ON json_extract_path_text(locations.data, 'holdingId') = ih.id
    LEFT JOIN inventory_locations AS il2 ON ih.permanent_location_id = il2.id
    LEFT JOIN inventory_instances ON json_extract_path_text(po_lines.data, 'instanceId') = inventory_instances.id
    LEFT JOIN organization_organizations ON json_extract_path_text(po_purchase_orders.data, 'vendor') = organization_organizations.id
    LEFT JOIN configuration_entries ON json_extract_path_text(po_purchase_orders.data, 'billTo') = configuration_entries.id
    LEFT JOIN user_users ON json_extract_path_text(po_purchase_orders.data, 'metadata', 'createdByUserId') = user_users.id;

CREATE INDEX ON po_instance (po_number);

CREATE INDEX ON po_instance (po_line_number);

CREATE INDEX ON po_instance (vendor_code);

CREATE INDEX ON po_instance (created_by);

CREATE INDEX ON po_instance (po_workflow_status);

CREATE INDEX ON po_instance (status_approved);

CREATE INDEX ON po_instance (created_date);

CREATE INDEX ON po_instance (created_location);

CREATE INDEX ON po_instance (pol_instance_id);

CREATE INDEX ON po_instance (pol_instance_hrid);

CREATE INDEX ON po_instance (pol_location_id);

CREATE INDEX ON po_instance (pol_location_name);

CREATE INDEX ON po_instance (pol_location_source);

CREATE INDEX ON po_instance (publication_date);

CREATE INDEX ON po_instance (publisher);

CREATE INDEX ON po_instance (requester);

CREATE INDEX ON po_instance (rush);

CREATE INDEX ON po_instance (selector);

VACUUM ANALYZE po_instance;

