DROP TABLE IF EXISTS folio_reporting.po_instance;

CREATE TABLE folio_reporting.po_instance AS
SELECT
    po_purchase_orders.po_number AS po_number,
    organization_organizations.code AS vendor_code,
    json_extract_path_text(po_purchase_orders.data, 'approved')::boolean AS status_approved,
    json_extract_path_text(po_purchase_orders.data, 'metadata', 'createdDate') AS created_date,
    json_extract_path_text(po_purchase_orders.data, 'metadata', 'createdByUserId') AS created_by,
    json_extract_path_text(configuration_entries.value::json, 'name') AS created_location,
    json_extract_path_text(po_lines.data, 'instanceId') AS pol_instance_id,
    inventory_instances.title AS title,
    json_extract_path_text(po_lines.data, 'publicationDate') AS publication_date,
    json_extract_path_text(po_lines.data, 'publisher') AS publisher,
    json_extract_path_text(po_lines.data, 'requester') AS requester,
    json_extract_path_text(po_lines.data, 'rush')::boolean AS rush
FROM
    po_purchase_orders
    LEFT JOIN po_lines ON po_purchase_orders.id = json_extract_path_text(po_lines.data, 'purchaseOrderId')
    LEFT JOIN inventory_instances ON json_extract_path_text(po_lines.data, 'instanceId') = inventory_instances.id
    LEFT JOIN organization_organizations ON po_purchase_orders.vendor = organization_organizations.id
    LEFT JOIN configuration_entries ON json_extract_path_text(po_purchase_orders.data, 'billTo') = configuration_entries.id;

CREATE INDEX ON folio_reporting.po_instance (po_number);

CREATE INDEX ON folio_reporting.po_instance (vendor_code);

CREATE INDEX ON folio_reporting.po_instance (status_approved);

CREATE INDEX ON folio_reporting.po_instance (created_date);

CREATE INDEX ON folio_reporting.po_instance (created_by);

CREATE INDEX ON folio_reporting.po_instance (created_location);

CREATE INDEX ON folio_reporting.po_instance (pol_instance_id);

CREATE INDEX ON folio_reporting.po_instance (title);

CREATE INDEX ON folio_reporting.po_instance (publication_date);

CREATE INDEX ON folio_reporting.po_instance (publisher);

CREATE INDEX ON folio_reporting.po_instance (requester);

CREATE INDEX ON folio_reporting.po_instance (rush);

