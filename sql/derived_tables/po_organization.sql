DROP TABLE IF EXISTS folio_reporting.po_organization;

CREATE TABLE folio_reporting.po_organization AS
SELECT
    po_number AS po_number,
    vendor AS vendor_id,
    oo.id AS org_id,
    oo.code AS org_code,
    oo.name AS org_name,
    json_extract_path_text(oo.data, 'description') AS org_description,
    oc.first_name AS contact_first_name,
    oc.last_name AS contact_last_name
FROM
    po_purchase_orders AS ppo
    LEFT JOIN organization_organizations AS oo ON ppo.vendor = oo.id
    LEFT JOIN organization_contacts AS oc ON oo.id = oc.id;

CREATE INDEX ON folio_reporting.po_organization (po_number);

CREATE INDEX ON folio_reporting.po_organization (vendor_id);

CREATE INDEX ON folio_reporting.po_organization (org_id);

CREATE INDEX ON folio_reporting.po_organization (org_code);

CREATE INDEX ON folio_reporting.po_organization (org_name);

CREATE INDEX ON folio_reporting.po_organization (org_description);

CREATE INDEX ON folio_reporting.po_organization (contact_first_name);

CREATE INDEX ON folio_reporting.po_organization (contact_last_name);

