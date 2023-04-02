--metadb:table po_lines_phys_mat_type

-- Create a derived table that extract physical resource material types from purchase order lines

DROP TABLE IF EXISTS po_lines_phys_mat_type;

CREATE TABLE po_lines_phys_mat_type AS
/* Subquery to extract nested JSON data */
WITH temp_pol_phys_mat_type AS (
    SELECT
        pol.id AS pol_id,
        jsonb_extract_path_text(jsonb, 'physical', 'materialType')::uuid AS pol_phys_mat_type_id
    FROM
        folio_orders.po_line AS pol
)
/* Main query */
SELECT
    tppmt.pol_id,
    tppmt.pol_phys_mat_type_id,
    imt.name AS pol_mat_type_name
FROM
    temp_pol_phys_mat_type AS tppmt
    LEFT JOIN folio_inventory.material_type__t AS imt ON imt.id = tppmt.pol_phys_mat_type_id;

CREATE INDEX ON po_lines_phys_mat_type (pol_id);

CREATE INDEX ON po_lines_phys_mat_type (pol_phys_mat_type_id);

CREATE INDEX ON po_lines_phys_mat_type (pol_mat_type_name);

COMMENT ON COLUMN po_lines_phys_mat_type.pol_id IS 'UUID identifying this purchase order line';

COMMENT ON COLUMN po_lines_phys_mat_type.pol_phys_mat_type_id IS 'UUID of the material Type';

COMMENT ON COLUMN po_lines_phys_mat_type.pol_mat_type_name IS 'Name of the material type';

VACUUM ANALYZE  po_lines_phys_mat_type;
