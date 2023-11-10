DROP TABLE IF EXISTS po_organization;

CREATE TABLE po_organization AS
SELECT
    ppo.data #>> '{poNumber}' AS po_number,
    (ppo.data #>> '{vendor}')::uuid AS vendor_id,
    oo.id AS org_id,
    oo.code AS org_code,
    oo.name AS org_name,
    oo.data #>> '{description}' AS org_description,
    oc.data #>> '{firstName}' AS contact_first_name,
    oc.data #>> '{lastName}' AS contact_last_name
FROM
    po_purchase_orders AS ppo
    LEFT JOIN organization_organizations AS oo ON (ppo.data #>> '{vendor}')::uuid = oo.id::uuid
    LEFT JOIN organization_contacts AS oc ON oo.id = oc.id;

