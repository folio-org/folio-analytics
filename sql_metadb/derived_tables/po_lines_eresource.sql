-- Creates a derived table for eresource data in purchase order lines

DROP TABLE IF EXISTS po_lines_eresource;

CREATE TABLE po_lines_eresource AS
WITH temp_eresource AS (
    SELECT
        pol.id AS pol_id,
        jsonb_extract_path_text(jsonb, 'eresource', 'locationId')::uuid AS pol_location_id,
        jsonb_extract_path_text(jsonb, 'eresource', 'accessProvider')::uuid AS access_provider,
        jsonb_extract_path_text(jsonb, 'eresource', 'activated') AS pol_activated,
        jsonb_extract_path_text(jsonb, 'eresource', 'activationDue') AS pol_activation_due,
        jsonb_extract_path_text(jsonb, 'eresource', 'createInventory') AS pol_create_inventory,
        jsonb_extract_path_text(jsonb, 'eresource', 'expectedActivation')::timestamptz AS pol_expected_activation,
        jsonb_extract_path_text(jsonb, 'eresource', 'license') AS pol_license,
        jsonb_extract_path_text(jsonb, 'eresource', 'license', 'description') AS pol_license_desc,
        jsonb_extract_path_text(jsonb, 'eresource', 'materialType')::uuid AS pol_material_type_id,
        jsonb_extract_path_text(jsonb, 'eresource', 'trial') AS pol_trial,
        jsonb_extract_path_text(jsonb, 'eresource', 'userLimit') AS pol_user_limit,
        jsonb_extract_path_text(jsonb, 'eresource', 'resourceUrl') AS pol_resource_url
    FROM
        folio_orders.po_line AS pol
)
SELECT
    te.pol_id,
    te.pol_location_id,
    il.name AS location_name,
    te. access_provider AS pol_access_provider,
    oo.name AS provider_org_name,
    te.pol_activated,
    te.pol_activation_due,
    te.pol_create_inventory,
    te.pol_expected_activation,
    te.pol_license,
    te.pol_license_desc,
    te.pol_material_type_id,
    imt.name AS pol_er_mat_type_name,
    te.pol_trial,
    te.pol_user_limit,
    te.pol_resource_url
FROM
    temp_eresource AS te
    LEFT JOIN folio_inventory.material_type__t AS imt ON imt.id = te.pol_material_type_id
    LEFT JOIN folio_inventory.location__t AS il ON il.id = te.pol_location_id
    LEFT JOIN folio_organizations.organizations__t AS oo ON oo.id = te.access_provider;

CREATE INDEX ON po_lines_eresource (pol_id);

CREATE INDEX ON po_lines_eresource (pol_location_id);

CREATE INDEX ON po_lines_eresource (location_name);

CREATE INDEX ON po_lines_eresource (pol_access_provider);

CREATE INDEX ON po_lines_eresource (provider_org_name);

CREATE INDEX ON po_lines_eresource (pol_activated);

CREATE INDEX ON po_lines_eresource (pol_activation_due);

CREATE INDEX ON po_lines_eresource (pol_create_inventory);

CREATE INDEX ON po_lines_eresource (pol_expected_activation);

CREATE INDEX ON po_lines_eresource (pol_license);

CREATE INDEX ON po_lines_eresource (pol_license_desc);

CREATE INDEX ON po_lines_eresource (pol_material_type_id);

CREATE INDEX ON po_lines_eresource (pol_er_mat_type_name);

CREATE INDEX ON po_lines_eresource (pol_trial);

CREATE INDEX ON po_lines_eresource (pol_user_limit);

CREATE INDEX ON po_lines_eresource (pol_resource_url);

VACUUM ANALYZE po_lines_eresource;

