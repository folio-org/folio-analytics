DROP TABLE IF EXISTS po_lines_physical;

-- Creates a derived table for physical resources data in purchase order lines.

CREATE TABLE po_lines_physical AS
WITH temp_phys AS (
    SELECT
        pol.id AS pol_id,
        jsonb_extract_path_text(jsonb, 'physical', 'createInventory') AS pol_phys_create_inventory,
        jsonb_extract_path_text(jsonb, 'physical', 'materialType')::uuid AS pol_phys_mat_type_id,
        jsonb_extract_path_text(jsonb, 'physical', 'materialSupplier')::uuid AS pol_phys_mat_supplier_id,
        jsonb_extract_path_text(jsonb, 'physical', 'expectedReceiptDate')::timestamptz AS pol_phys_expected_receipt_date,
        jsonb_extract_path_text(jsonb, 'physical', 'receiptDue')::timestamptz AS pol_phys_receipt_due,
        physical_volumes.data #>> '{}' AS pol_volumes,
        physical_volumes.ordinality AS pol_volumes_ordinality
    FROM
        folio_orders.po_line AS pol
        CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(jsonb, 'physical', 'volumes')) WITH ORDINALITY AS physical_volumes (data)
)
SELECT
    tp.pol_id,
    tp.pol_phys_create_inventory,
    tp.pol_phys_mat_type_id,
    imt.name AS pol_phys_mat_type_name,
    tp.pol_phys_mat_supplier_id,
    oo.name AS supplier_org_name,
    tp.pol_phys_expected_receipt_date,
    tp.pol_phys_receipt_due,
    tp.pol_volumes,
    tp.pol_volumes_ordinality,
    tp.pol_phys_volumes_description
FROM
    temp_phys AS tp
    LEFT JOIN folio_inventory.material_type__t AS imt ON imt.id = tp.pol_phys_mat_type_id
    LEFT JOIN folio_organizations.organizations__t AS oo ON oo.id = tp.pol_phys_mat_supplier_id;

CREATE INDEX ON po_lines_physical (pol_id);

CREATE INDEX ON po_lines_physical (pol_phys_create_inventory);

CREATE INDEX ON po_lines_physical (pol_phys_mat_type_id);

CREATE INDEX ON po_lines_physical (pol_phys_mat_type_name);

CREATE INDEX ON po_lines_physical (pol_phys_mat_supplier_id);

CREATE INDEX ON po_lines_physical (supplier_org_name);

CREATE INDEX ON po_lines_physical (pol_phys_expected_receipt_date);

CREATE INDEX ON po_lines_physical (pol_phys_receipt_due);

CREATE INDEX ON po_lines_physical (pol_volumes);

CREATE INDEX ON po_lines_physical (pol_volumes_ordinality);

COMMENT ON COLUMN po_lines_physical.pol_id IS 'UUID identifying this purchase order line';

COMMENT ON COLUMN po_lines_physical.pol_phys_create_inventory IS 'Shows what inventory objects need to be created for electronic resource';

COMMENT ON COLUMN po_lines_physical.pol_phys_mat_type_id IS 'UUID of the material Type';

COMMENT ON COLUMN po_lines_physical.pol_phys_mat_type_name IS 'Label for the material type';

COMMENT ON COLUMN po_lines_physical.pol_phys_mat_supplier_id IS 'UUID of the material supplier record';

COMMENT ON COLUMN po_lines_physical.supplier_org_name IS 'UUID of this purchase order';

COMMENT ON COLUMN po_lines_physical.pol_phys_expected_receipt_date IS 'Vendor agreed date prior to the Receipt Due date item is expected to be received by';

COMMENT ON COLUMN po_lines_physical.pol_phys_receipt_due IS 'Date item should be received by';

COMMENT ON COLUMN po_lines_physical.pol_volumes IS 'List of volumes included to the physical material';

COMMENT ON COLUMN po_lines_physical.pol_volumes_ordinality IS 'Volumes ordinality';

VACUUM ANALYZE po_lines_physical;

