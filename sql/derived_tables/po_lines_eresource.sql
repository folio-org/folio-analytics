-- Create a derived table for Purchase Order Line Eresource data.

DROP TABLE IF EXISTS po_lines_eresource;

CREATE TABLE po_lines_eresource AS
WITH temp_eresource AS (
    SELECT
        pol.id AS pol_id,
        json_extract_path_text(pol.data, 'eresource', 'accessProvider') AS access_provider,
        json_extract_path_text(pol.data, 'eresource', 'activated') AS pol_activated,
        json_extract_path_text(pol.data, 'eresource', 'activationDue') AS pol_activation_due,
        json_extract_path_text(pol.data, 'eresource', 'createInventory') AS pol_create_inventory,
        json_extract_path_text(pol.data, 'eresource', 'expectedActivation') AS pol_expected_activation,
        json_extract_path_text(pol.data, 'eresource', 'license', 'code') AS pol_license_code,
        json_extract_path_text(pol.data, 'eresource', 'license', 'description') AS pol_license_desc,
        json_extract_path_text(pol.data, 'eresource', 'license', 'reference') AS pol_license_reference,
        json_extract_path_text(pol.data, 'eresource', 'materialType') AS pol_material_type,
        json_extract_path_text(pol.data, 'eresource', 'trial') AS pol_trial,
        json_extract_path_text(pol.data, 'eresource', 'userLimit') AS pol_user_limit,
        json_extract_path_text(pol.data, 'eresource', 'resourceUrl') AS pol_resource_url,
        json_extract_path_text(locations.data, 'holdingId') AS pol_holding_id,
        ih.hrid AS pol_holding_hrid,
        CASE WHEN json_extract_path_text(locations.data, 'locationId') IS NOT NULL THEN json_extract_path_text(locations.data, 'locationId')
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
        CROSS JOIN json_array_elements(json_extract_path(pol.data, 'locations')) AS locations (data)
        LEFT JOIN inventory_locations AS il ON json_extract_path_text(locations.data, 'locationId') = il.id
        LEFT JOIN inventory_holdings AS ih ON json_extract_path_text(locations.data, 'holdingId') = ih.id
        LEFT JOIN inventory_locations AS il2 ON il2.id = ih.permanent_location_id
    WHERE
        json_extract_path(pol.data, 'eresource') IS NOT NULL
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

CREATE INDEX ON po_lines_eresource (pol_material_type);

CREATE INDEX ON po_lines_eresource (pol_er_mat_type_name);

CREATE INDEX ON po_lines_eresource (pol_trial);

CREATE INDEX ON po_lines_eresource (pol_user_limit);

CREATE INDEX ON po_lines_eresource (pol_resource_url);

VACUUM ANALYZE po_lines_eresource;
