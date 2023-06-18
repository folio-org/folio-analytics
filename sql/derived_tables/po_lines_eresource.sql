-- Create a derived table for Purchase Order Line Eresource data.

DROP TABLE IF EXISTS po_lines_eresource;

CREATE TABLE po_lines_eresource AS
WITH temp_eresource AS (
    SELECT
        pol.id AS pol_id,
        pol.data #>> '{eresource,accessProvider}' AS access_provider,
        pol.data #>> '{eresource,activated}' AS pol_activated,
        pol.data #>> '{eresource,activationDue}' AS pol_activation_due,
        pol.data #>> '{eresource,createInventory}' AS pol_create_inventory,
        pol.data #>> '{eresource,expectedActivation}' AS pol_expected_activation,
        pol.data #>> '{eresource,license,code}' AS pol_license_code,
        pol.data #>> '{eresource,license,description}' AS pol_license_desc,
        pol.data #>> '{eresource,license,reference}' AS pol_license_reference,
        (pol.data #>> '{eresource,materialType}')::uuid AS pol_material_type,
        pol.data #>> '{eresource,trial}' AS pol_trial,
        pol.data #>> '{eresource,userLimit}' AS pol_user_limit,
        pol.data #>> '{eresource,resourceUrl}' AS pol_resource_url,
        (locations.data #>> '{holdingId}')::uuid AS pol_holding_id,
        ih.hrid AS pol_holding_hrid,
        CASE WHEN (locations.data #>> '{locationId}') IS NOT NULL THEN (locations.data #>> '{locationId}')::uuid
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
        po_lines AS pol
        CROSS JOIN jsonb_array_elements((pol.data #> '{locations}')::jsonb) AS locations (data)
        LEFT JOIN inventory_locations AS il ON (locations.data #>> '{locationId}')::uuid = il.id
        LEFT JOIN inventory_holdings AS ih ON (locations.data #>> '{holdingId}')::uuid = ih.id
        LEFT JOIN inventory_locations AS il2 ON il2.id = ih.permanent_location_id
    WHERE
        pol.data #> '{eresource}' IS NOT NULL
)
SELECT
    te.pol_id,
    te.pol_holding_id AS pol_holding_id,
    te.pol_holding_hrid AS pol_holding_hrid,
    te.pol_location_id,
    te.location_name,
    te.pol_location_source,
    te.access_provider AS pol_access_provider,
    oo.name AS provider_org_name,
    te.pol_activated,
    te.pol_activation_due,
    te.pol_create_inventory,
    te.pol_expected_activation,
    te.pol_license_code,
    te.pol_license_desc,
    te.pol_license_reference,
    te.pol_material_type,
    imt.name AS pol_er_mat_type_name,
    te.pol_trial,
    te.pol_user_limit,
    te.pol_resource_url
FROM
    temp_eresource AS te
    LEFT JOIN inventory_material_types AS imt ON imt.id = te.pol_material_type
    LEFT JOIN organization_organizations AS oo ON oo.id = te.access_provider;

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

COMMENT ON COLUMN po_lines_eresource.pol_material_type IS 'UUID of the material Type';

COMMENT ON COLUMN po_lines_eresource.pol_er_mat_type_name IS 'Material Type name';

COMMENT ON COLUMN po_lines_eresource.pol_trial IS 'whether or not this is a trial';

COMMENT ON COLUMN po_lines_eresource.pol_user_limit IS 'the concurrent user-limit';

COMMENT ON COLUMN po_lines_eresource.pol_resource_url IS 'Electronic resource can be access via this URL';
