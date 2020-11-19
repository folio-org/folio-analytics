DROP TABLE IF EXISTS local.po_lines_physical;
--Create a local table for Purchase Order Lines Physical material data.
CREATE TABLE local.po_lines_physical AS
WITH temp_phys AS (
	SELECT
    	pol.id AS pol_id,
    	json_extract_path_text(data, 'physical', 'createInventory') AS pol_phys_create_inventory,
    	json_extract_path_text(data, 'physical', 'materialType') AS pol_phys_mat_type,
    	json_extract_path_text(data, 'physical', 'materialSupplier') AS pol_phys_mat_supplier,
    	json_extract_path_text(data, 'physical', 'expectedReceiptDate') AS pol_phys_expected_receipt_date,
    	json_extract_path_text(data, 'physical', 'receiptDue') AS pol_phys_receipt_due,
    	json_array_elements_text(json_extract_path(data, 'physical', 'volumes')) AS pol_volumes,
    	json_extract_path_text(data, 'physical','volumes', 'description') AS pol_phys_volumes_description
	FROM
    	po_lines AS pol
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
    tp.pol_phys_volumes_description

FROM 
	temp_phys AS tp
	LEFT JOIN inventory_material_types AS imt 
		ON imt.id = tp.pol_phys_mat_type
	LEFT JOIN organization_organizations AS oo
	 	ON oo.id = tp.pol_phys_mat_supplier;
	 	
CREATE INDEX ON local.po_lines_physical (pol_id);

CREATE INDEX ON local.po_lines_physical (pol_phys_create_inventory);

CREATE INDEX ON local.po_lines_physical (pol_phys_mat_type);

CREATE INDEX ON local.po_lines_physical (pol_er_mat_type_name);

CREATE INDEX ON local.po_lines_physical (pol_phys_mat_supplier);

CREATE INDEX ON local.po_lines_physical (supplier_org_name);

CREATE INDEX ON local.po_lines_physical (pol_phys_expected_receipt_date);

CREATE INDEX ON local.po_lines_physical (pol_phys_receipt_due);

CREATE INDEX ON local.po_lines_physical (pol_volumes);

CREATE INDEX ON local.po_lines_physical (pol_phys_volumes_description);

