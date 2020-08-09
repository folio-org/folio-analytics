CREATE TABLE local.acrl_location_filtering AS
WITH parameters AS (
    SELECT * FROM local.acrl_parameters
)
SELECT
        i.id AS item_id,
        itpl."name" AS perm_location_name,
        ittl."name" AS temp_location_name,
        itel."name" AS effective_location_name,
        inst."name" AS institution_name,
        cmp."name" AS campus_name,
        lib."name" AS library_name
    FROM inventory_items AS i
    LEFT JOIN inventory_locations AS itpl
        ON i.permanent_location_id = itpl.id
    LEFT JOIN inventory_locations AS ittl
        ON i.temporary_location_id = ittl.id
    LEFT JOIN inventory_locations AS itel
        ON i.effective_location_id = itel.id
    LEFT JOIN inventory_libraries AS lib
        ON itpl.library_id = lib.id
    LEFT JOIN inventory_campuses AS cmp
        ON itpl.campus_id = cmp.id
    LEFT JOIN inventory_institutions AS inst
        ON itpl.institution_id = inst.id
        WHERE
        (itpl."name" = (SELECT items_permanent_location_filter FROM parameters)
               OR '' = (SELECT items_permanent_location_filter FROM parameters))
    AND (ittl."name" = (SELECT items_temporary_location_filter FROM parameters)
               OR '' = (SELECT items_temporary_location_filter FROM parameters))
    AND (itel."name" = (SELECT items_effective_location_filter FROM parameters)
               OR '' = (SELECT items_effective_location_filter FROM parameters))
    AND (lib."name" = (SELECT library_filter FROM parameters)
                   OR '' = (SELECT library_filter FROM parameters))
        AND (cmp."name" = (SELECT campus_filter FROM parameters)
               OR '' = (SELECT campus_filter FROM parameters))
        AND (inst."name" = (SELECT institution_filter FROM parameters)
                   OR '' = (SELECT institution_filter FROM parameters));

CREATE INDEX ON local.acrl_location_filtering (item_id);

VACUUM local.acrl_location_filtering;
ANALYZE local.acrl_location_filtering;
