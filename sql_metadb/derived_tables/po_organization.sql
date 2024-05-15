--metadb:table po_organization
--metadb:require folio_organizations.contacts__t.id uuid
--metadb:require folio_organizations.contacts__t.first_name text
--metadb:require folio_organizations.contacts__t.last_name text

--Create a local table for contact information for organization or vendor used in PO.

-- 1. Get the contact id from the data blob

DROP TABLE IF EXISTS po_organization;

CREATE TABLE po_organization AS

WITH recs AS 
(SELECT DISTINCT
   oo.id AS org_id,
   JSONB_EXTRACT_PATH_TEXT (oo.jsonb, 'code') as org_code,
   JSONB_EXTRACT_PATH_TEXT (oo.jsonb, 'name') as org_name,
   JSONB_EXTRACT_PATH_TEXT (oo.jsonb, 'isVendor') as is_vendor,
   JSONB_EXTRACT_PATH_TEXT (JSONB_ARRAY_ELEMENTS (JSONB_EXTRACT_PATH (oo.jsonb, 'aliases')),'value') AS alias,
   JSONB_EXTRACT_PATH_TEXT (JSONB_ARRAY_ELEMENTS (JSONB_EXTRACT_PATH (oo.jsonb, 'aliases')),'description') AS alias_description,
   TRIM ('"' from JSONB_ARRAY_ELEMENTS ((oo.jsonb #>'{contacts}')::JSONB)::VARCHAR) AS contact_id

FROM folio_organizations.organizations AS oo
),

-- 2. Get the contact information from the folio_organizations.contacts table and join to the contact id extracted from the folio_organizations.organizations table

recs2 AS 
(SELECT DISTINCT
	recs.org_id,
	recs.org_name,
	recs.org_code,
	recs.is_vendor,
	recs.alias,
	recs.alias_description,
	recs.contact_id AS oo_contact_id,
	oc.id AS oc_concact_id,
	oc.creation_date::date AS created_date, 
	jsonb_extract_path_text (oc.jsonb,'metadata','updatedDate') as updated_date,
	jsonb_extract_path_text (oc.jsonb,'metadata','updatedByUserId') as updated_by_user_id,
	concat (jsonb_extract_path_text (uu.jsonb,'personal','lastName'),' ',jsonb_extract_path_text (uu.jsonb,'personal','firstName')) as updated_by,
	jsonb_extract_path_text (oc.jsonb,'lastname') as contact_last_name,
	jsonb_extract_path_text (oc.jsonb,'firstName') as contact_first_name,
	jsonb_extract_path_text (oc.jsonb,'notes') as notes,
	JSONB_EXTRACT_PATH_TEXT (JSONB_ARRAY_ELEMENTS (JSONB_EXTRACT_PATH (oc.jsonb, 'addresses')),'addressLine1') AS address_line_1,
	JSONB_EXTRACT_PATH_TEXT (JSONB_ARRAY_ELEMENTS (JSONB_EXTRACT_PATH (oc.jsonb, 'addresses')),'addressLine2') AS address_line_2,
	JSONB_EXTRACT_PATH_TEXT (JSONB_ARRAY_ELEMENTS (JSONB_EXTRACT_PATH (oc.jsonb, 'addresses')),'city') AS city,
	JSONB_EXTRACT_PATH_TEXT (JSONB_ARRAY_ELEMENTS (JSONB_EXTRACT_PATH (oc.jsonb, 'addresses')),'stateRegion') AS state_region,
	JSONB_EXTRACT_PATH_TEXT (JSONB_ARRAY_ELEMENTS (JSONB_EXTRACT_PATH (oc.jsonb, 'addresses')),'country') AS country,
	JSONB_EXTRACT_PATH_TEXT (JSONB_ARRAY_ELEMENTS (JSONB_EXTRACT_PATH (oc.jsonb, 'addresses')),'zipCode') AS zip_code,
	JSONB_EXTRACT_PATH_TEXT (JSONB_ARRAY_ELEMENTS (JSONB_EXTRACT_PATH (oc.jsonb, 'addresses')),'isPrimary') AS is_primary,
	JSONB_EXTRACT_PATH_TEXT (JSONB_ARRAY_ELEMENTS (JSONB_EXTRACT_PATH (oc.jsonb, 'emails')),'value') AS email_address,
	JSONB_EXTRACT_PATH_TEXT (JSONB_ARRAY_ELEMENTS (JSONB_EXTRACT_PATH (oc.jsonb, 'phoneNumbers')),'phoneNumber') AS phone_number,
	JSONB_EXTRACT_PATH_TEXT (JSONB_ARRAY_ELEMENTS (JSONB_EXTRACT_PATH (oc.jsonb, 'urls')),'value') AS url,
	JSONB_EXTRACT_PATH_TEXT (JSONB_ARRAY_ELEMENTS (JSONB_EXTRACT_PATH (oc.jsonb, 'urls')),'description') AS url_description

FROM recs
	FULL OUTER JOIN folio_organizations.contacts AS oc 
	ON recs.contact_id::UUID = oc.id::UUID
	
	LEFT JOIN folio_users.users AS uu 
	ON jsonb_extract_path_text (oc.jsonb,'metadata','updatedByUserId')::UUID = uu.id::UUID
)

--3. Join results of recs2 to the purchase_order__t table to get the vendor contact information

SELECT distinct
	ppo.po_number,
    ppo.vendor AS vendor_id,
	oo.id AS organization_id,
	oo.code AS organization_code,
	oo.name AS organization_name,
	oo.description AS organization_description,
	recs2.is_vendor,
	recs2.contact_first_name,
	recs2.contact_last_name,
	recs2.notes,
	recs2.address_line_1,
	recs2.address_line_2,
	recs2.city,
	recs2.state_region,
	recs2.country,
	recs2.zip_code,
	recs2.is_primary,
	recs2.email_address,
	recs2.phone_number,
	recs2.url,
	recs2.url_description

FROM folio_organizations.organizations__t AS oo 
	LEFT JOIN recs2 
	ON oo.id::UUID = recs2.org_id::UUID
	
	INNER JOIN folio_orders.purchase_order__t AS ppo -- join the organization_id to the vendor id in the po_purchase_orders table
	ON oo.id::UUID = ppo.vendor::UUID

ORDER BY po_number, oo.name
;

COMMENT ON COLUMN po_organization.po_number IS 'A human readable number assigned to PO';

COMMENT ON COLUMN po_organization.vendor_id IS 'The unique UUID for the vendor';

COMMENT ON COLUMN po_organization.organization_id IS 'The unique UUID for the organization';

COMMENT ON COLUMN po_organization.organization_code IS 'The code of the organization';

COMMENT ON COLUMN po_organization.organization_name IS 'The name of the organization';

COMMENT ON COLUMN po_organization.organization_description IS 'The description for the organization';

COMMENT ON COLUMN po_organization.is_vendor IS 'Indication for the organization if also a vendor';

COMMENT ON COLUMN po_organization.contact_first_name IS 'Contact First name for the organization';

COMMENT ON COLUMN po_organization.contact_last_name IS  'Contact Last name for the organization';

COMMENT ON COLUMN po_organization.notes IS  'Notes for this contact';

COMMENT ON COLUMN po_organization.address_line_1 IS  'First line of this address';

COMMENT ON COLUMN po_organization.address_line_2 IS  'Second line of this address';

COMMENT ON COLUMN po_organization.city IS  'City for this address';

COMMENT ON COLUMN po_organization.state_region IS  'State or Region for this address';

COMMENT ON COLUMN po_organization.country IS  'Country for this address';

COMMENT ON COLUMN po_organization.zip_code IS  'Zip Code for this address';

COMMENT ON COLUMN po_organization.is_primary IS  'Used to set this address as primary for the organization.';

COMMENT ON COLUMN po_organization.email_address IS  'Email address for the contact';

COMMENT ON COLUMN po_organization.phone_number IS  'Phone number for the contact';

COMMENT ON COLUMN po_organization.url IS  'URL of the organization';

COMMENT ON COLUMN po_organization.url_description IS  'URL description for the organization';
