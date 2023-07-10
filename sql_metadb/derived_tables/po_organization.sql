--metadb:table po_organization
--metadb:require folio_organizations.contacts__t.id uuid
--metadb:require folio_organizations.contacts__t.first_name text
--metadb:require folio_organizations.contacts__t.last_name text

--Create a local table for contact information for organization or vendor used in PO.

DROP TABLE IF EXISTS po_organization;

CREATE TABLE po_organization AS
SELECT
    ppo.po_number AS po_number,
    ppo.vendor AS vendor_id,
    oo.id AS organization_id,
    oo.code AS organization_code,
    oo.name AS organization_name,
    oo.description AS organization_description,
    oo.is_vendor,
    oc.first_name AS contact_first_name,
    oc.last_name AS contact_last_name
FROM
    folio_orders.purchase_order__t AS ppo
    LEFT JOIN folio_organizations.organizations__t AS oo ON ppo.vendor = oo.id
    LEFT JOIN folio_organizations.contacts__t AS oc ON oo.id = oc.id;

COMMENT ON COLUMN po_organization.po_number IS 'A human readable number assigned to PO';

COMMENT ON COLUMN po_organization.vendor_id IS 'The unique UUID for the vendor';

COMMENT ON COLUMN po_organization.organization_id IS 'The unique UUID for the organization';

COMMENT ON COLUMN po_organization.organization_code IS 'The code of the organization';

COMMENT ON COLUMN po_organization.organization_name IS 'The name of the organization';

COMMENT ON COLUMN po_organization.organization_description IS 'The description for the organization';

COMMENT ON COLUMN po_organization.is_vendor IS 'Indication for the organization if also a vendor';

COMMENT ON COLUMN po_organization.contact_first_name IS 'Contact First name for the organization';

COMMENT ON COLUMN po_organization.contact_last_name IS  'Contact Last name for the organization';
