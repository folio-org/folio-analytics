DROP TABLE IF EXISTS po_organization;

CREATE TABLE po_organization AS
SELECT
    json_extract_path_text(ppo.data, 'poNumber') AS po_number,
    json_extract_path_text(ppo.data, 'vendor') AS vendor_id,
    oo.id AS org_id,
    oo.code AS org_code,
    oo.name AS org_name,
    json_extract_path_text(oo.data, 'description') AS org_description,
    json_extract_path_text(oc.data, 'firstName') AS contact_first_name,
    json_extract_path_text(oc.data, 'lastName') AS contact_last_name
FROM
    po_purchase_orders AS ppo
    LEFT JOIN organization_organizations AS oo ON json_extract_path_text(ppo.data, 'vendor') = oo.id
    LEFT JOIN organization_contacts AS oc ON oo.id = oc.id;

