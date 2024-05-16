--metadb:table locations_libraries

-- Create derived table that combines institution, campus, library, and location information

DROP TABLE IF EXISTS locations_libraries;

CREATE TABLE locations_libraries AS
SELECT
    cmp.id AS campus_id,
    cmp.name AS campus_name,
    cmp.code AS campus_code,
    loc.id AS location_id,
    loc.name AS location_name,
    loc.code AS location_code,
    loc.discovery_display_name AS discovery_display_name,
    lib.id AS library_id,
    lib.name AS library_name,
    lib.code AS library_code,
    inst.id AS institution_id,
    inst.name AS institution_name,
    inst.code AS institution_code
FROM
    folio_inventory.loccampus__t AS cmp
    LEFT JOIN folio_inventory.location__t AS loc ON cmp.id = loc.campus_id::uuid
    LEFT JOIN folio_inventory.locinstitution__t AS inst ON loc.institution_id::uuid = inst.id
    LEFT JOIN folio_inventory.loclibrary__t AS lib ON loc.library_id::uuid = lib.id;
