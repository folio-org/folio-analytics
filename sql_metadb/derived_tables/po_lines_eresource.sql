--metadb:table po_lines_eresource

-- Creates a derived table for eresource data in purchase order lines

DROP TABLE IF EXISTS po_lines_eresource;

CREATE TABLE po_lines_eresource AS
WITH temp_eresource AS (
    SELECT
        pol.id AS pol_id,
        jsonb_extract_path_text(pol.jsonb, 'eresource', 'accessProvider')::uuid AS access_provider,
        jsonb_extract_path_text(pol.jsonb, 'eresource', 'activated') AS pol_activated,
        jsonb_extract_path_text(pol.jsonb, 'eresource', 'activationDue') AS pol_activation_due,
        jsonb_extract_path_text(pol.jsonb, 'eresource', 'createInventory') AS pol_create_inventory,
        jsonb_extract_path_text(pol.jsonb, 'eresource', 'expectedActivation')::timestamptz AS pol_expected_activation,
        jsonb_extract_path_text(pol.jsonb, 'eresource', 'license', 'code') AS pol_license_code,
        jsonb_extract_path_text(pol.jsonb, 'eresource', 'license', 'description') AS pol_license_desc,
        jsonb_extract_path_text(pol.jsonb, 'eresource', 'license', 'reference') AS pol_license_reference,
        jsonb_extract_path_text(pol.jsonb, 'eresource', 'materialType')::uuid AS pol_material_type_id,
        jsonb_extract_path_text(pol.jsonb, 'eresource', 'trial') AS pol_trial,
        jsonb_extract_path_text(pol.jsonb, 'eresource', 'userLimit') AS pol_user_limit,
        jsonb_extract_path_text(pol.jsonb, 'eresource', 'resourceUrl') AS pol_resource_url,
        jsonb_extract_path_text(locations.data, 'holdingId')::uuid AS pol_holding_id,
        ih.hrid AS pol_holding_hrid,
        CASE WHEN jsonb_extract_path_text(locations.data, 'locationId') IS NOT NULL THEN jsonb_extract_path_text(locations.data, 'locationId')::uuid
             ELSE ih.permanent_location_id
            END AS pol_location_id,
        CASE WHEN il.name IS NOT NULL THEN il.name
             ELSE il2.name
            END AS location_name,
        CASE WHEN il.name IS NOT NULL THEN 'pol_location'
             WHEN il2.name IS NOT NULL THEN 'pol_holding'
             ELSE 'no_source'
            END AS pol_location_source
    FROM
        folio_orders.po_line AS pol
        CROSS JOIN jsonb_array_elements(jsonb_extract_path(pol.jsonb, 'locations')) AS locations (data)
        LEFT JOIN folio_inventory.location__t AS il ON jsonb_extract_path_text(locations.data, 'locationId')::uuid = il.id
        LEFT JOIN folio_inventory.holdings_record__t AS ih ON jsonb_extract_path_text(locations.data, 'holdingId')::uuid = ih.id
        LEFT JOIN folio_inventory.location__t AS il2 ON il2.id = ih.permanent_location_id
    WHERE
        jsonb_extract_path(pol.jsonb, 'eresource') IS NOT NULL
)
SELECT
    te.pol_id,
    te.pol_holding_id AS pol_holding_id,
    te.pol_holding_hrid AS pol_holding_hrid,
    te.pol_location_id,
    te.location_name,
    te.pol_location_source,
    te. access_provider AS pol_access_provider,
    oo.name AS provider_org_name,
    te.pol_activated,
    te.pol_activation_due,
    te.pol_create_inventory,
    te.pol_expected_activation,
    te.pol_license_code,
    te.pol_license_desc,
    te.pol_license_reference,
    te.pol_material_type_id,
    imt.name AS pol_er_mat_type_name,
    te.pol_trial,
    te.pol_user_limit,
    te.pol_resource_url
FROM
    temp_eresource AS te
    LEFT JOIN folio_inventory.material_type__t AS imt ON imt.id = te.pol_material_type_id
    LEFT JOIN folio_organizations.organizations__t AS oo ON oo.id = te.access_provider;

CREATE INDEX ON po_lines_eresource (pol_id);

CREATE INDEX ON po_lines_eresource (pol_holding_id);

CREATE INDEX ON po_lines_eresource (pol_holding_hrid);

CREATE INDEX ON po_lines_eresource (pol_location_id);

CREATE INDEX ON po_lines_eresource (location_name);

CREATE INDEX ON po_lines_eresource (pol_location_source);

CREATE INDEX ON po_lines_eresource (pol_access_provider);

CREATE INDEX ON po_lines_eresource (provider_org_name);

CREATE INDEX ON po_lines_eresource (pol_activated);

CREATE INDEX ON po_lines_eresource (pol_activation_due);

CREATE INDEX ON po_lines_eresource (pol_create_inventory);

CREATE INDEX ON po_lines_eresource (pol_expected_activation);

CREATE INDEX ON po_lines_eresource (pol_license_code);

CREATE INDEX ON po_lines_eresource (pol_license_desc);

CREATE INDEX ON po_lines_eresource (pol_license_reference);

CREATE INDEX ON po_lines_eresource (pol_material_type_id);

CREATE INDEX ON po_lines_eresource (pol_er_mat_type_name);

CREATE INDEX ON po_lines_eresource (pol_trial);

CREATE INDEX ON po_lines_eresource (pol_user_limit);

CREATE INDEX ON po_lines_eresource (pol_resource_url);

COMMENT ON COLUMN po_lines_eresource.pol_id IS 'UUID identifying this purchase order line';

COMMENT ON COLUMN po_lines_eresource.pol_holding_id IS 'Holding UUID associated with order line';

COMMENT ON COLUMN po_lines_eresource.pol_holding_hrid IS 'the human readable ID, also called eye readable ID. A system-assigned sequential ID which maps to the Holding ID';

COMMENT ON COLUMN po_lines_eresource.pol_location_id IS 'UUID of the (inventory) location record';

COMMENT ON COLUMN po_lines_eresource.location_name IS 'Displayed location name';

COMMENT ON COLUMN po_lines_eresource.pol_location_source IS 'Shows if the displayed location is sourced from the pol_location_id or pol_holding_id';

COMMENT ON COLUMN po_lines_eresource.pol_access_provider IS 'UUID of the access provider';

COMMENT ON COLUMN po_lines_eresource.provider_org_name IS 'Displayed access provider name';

COMMENT ON COLUMN po_lines_eresource.pol_activated IS 'whether or not this resource is activated';

COMMENT ON COLUMN po_lines_eresource.pol_activation_due IS 'number of days until activation, from date of order placement';

COMMENT ON COLUMN po_lines_eresource.pol_create_inventory IS 'Shows what inventory objects need to be created for electronic resource';

COMMENT ON COLUMN po_lines_eresource.pol_expected_activation IS 'expected date the resource will be activated';

COMMENT ON COLUMN po_lines_eresource.pol_license_code IS 'license code';

COMMENT ON COLUMN po_lines_eresource.pol_license_desc IS 'license description';

COMMENT ON COLUMN po_lines_eresource.pol_license_reference IS 'license reference';

COMMENT ON COLUMN po_lines_eresource.pol_material_type_id IS 'UUID of the material Type';

COMMENT ON COLUMN po_lines_eresource.pol_er_mat_type_name IS 'Material Type name';

COMMENT ON COLUMN po_lines_eresource.pol_trial IS 'whether or not this is a trial';

COMMENT ON COLUMN po_lines_eresource.pol_user_limit IS 'the concurrent user-limit';

COMMENT ON COLUMN po_lines_eresource.pol_resource_url IS 'Electronic resource can be access via this URL';

VACUUM ANALYZE po_lines_eresource;

