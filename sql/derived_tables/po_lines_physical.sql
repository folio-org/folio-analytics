DROP TABLE IF EXISTS po_lines_physical;

-- Create a local table for Purchase Order Lines Physical material data.
CREATE TABLE po_lines_physical AS
WITH temp_phys AS (
    SELECT
        pol.id AS pol_id,
        pol.data #>> '{physical,createInventory}' AS pol_phys_create_inventory,
        pol.data #>> '{physical,materialType}' AS pol_phys_mat_type,
        pol.data #>> '{physical,materialSupplier}' AS pol_phys_mat_supplier,
        pol.data #>> '{physical,expectedReceiptDate}' AS pol_phys_expected_receipt_date,
        pol.data #>> '{physical,receiptDue}' AS pol_phys_receipt_due,
        physical_volumes.data #>> '{}' AS pol_volumes,
        physical_volumes.ordinality AS pol_volumes_ordinality,
        pol.data #>> '{physical,volumes,description}' AS pol_phys_volumes_description
    FROM
        po_lines AS pol
        CROSS JOIN LATERAL jsonb_array_elements((data #> '{physical,volumes}')::jsonb)
        WITH ORDINALITY AS physical_volumes (data)
)
SELECT
    tp.pol_id,
    tp.pol_phys_create_inventory,
    tp.pol_phys_mat_type,
    imt.name AS pol_er_mat_type_name,
    tp.pol_phys_mat_supplier,
    oo.name AS supplier_org_name,
    tp.pol_phys_expected_receipt_date,
    tp.pol_phys_receipt_due,
    tp.pol_volumes,
    tp.pol_volumes_ordinality,
    tp.pol_phys_volumes_description
FROM
    temp_phys AS tp
    LEFT JOIN inventory_material_types AS imt ON imt.id = tp.pol_phys_mat_type
    LEFT JOIN organization_organizations AS oo ON oo.id = tp.pol_phys_mat_supplier;

