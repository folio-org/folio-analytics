DROP TABLE IF EXISTS local.po_organizations;

CREATE TABLE local.po_organizations AS
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

CREATE INDEX ON local.po_organizations (po_number);

CREATE INDEX ON local.po_organizations (vendor_id);

CREATE INDEX ON local.po_organizations (org_id);

CREATE INDEX ON local.po_organizations (org_code);

CREATE INDEX ON local.po_organizations (org_name);

CREATE INDEX ON local.po_organizations (org_description);

CREATE INDEX ON local.po_organizations (contact_first_name);

CREATE INDEX ON local.po_organizations (contact_last_name);

CREATE INDEX ON local.po_organizations (contact_email);

CREATE INDEX ON local.po_organizations (contact_phone_number);

VACUUM local.po_organizations;

ANALYZE local.po_organizations;

