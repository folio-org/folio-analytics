DROP TABLE IF EXISTS po_lines_er_mat_type;

CREATE TABLE po_lines_er_mat_type AS
/* Subquery to extract nested JSON data */
WITH temp_pol_er_mat_type AS (
    SELECT
        pol.id AS pol_id,
        data #>> '{eresource,materialType}' AS pol_er_mat_type
    FROM
        po_lines AS pol)
    /* Main query */
    SELECT
        tpemt.pol_id,
        tpemt.pol_er_mat_type AS pol_er_mat_type_id,
        imt.name AS pol_er_mat_type_name
    FROM
        temp_pol_er_mat_type AS tpemt
    LEFT JOIN inventory_material_types AS imt ON imt.id = tpemt.pol_er_mat_type;

