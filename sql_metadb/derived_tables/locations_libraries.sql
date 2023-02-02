--metadb:table locations_libraries

DROP TABLE IF EXISTS locations_libraries;

CREATE TABLE locations_libraries AS
SELECT
    cmp.id AS campus_id,
    cmp.name AS campus_name,
    loc.id AS location_id,
    loc.name AS location_name,
    loc.discovery_display_name AS discovery_display_name,
    lib.id AS library_id,
    lib.name AS library_name,
    inst.id AS institution_id,
    inst.name AS institution_name
FROM
    folio_inventory.loccampus__t AS cmp
    LEFT JOIN folio_inventory.location__t AS loc ON cmp.id = loc.campus_id::uuid
    LEFT JOIN folio_inventory.locinstitution__t AS inst ON loc.institution_id::uuid = inst.id
    LEFT JOIN folio_inventory.loclibrary__t AS lib ON loc.library_id::uuid = lib.id;

CREATE INDEX ON locations_libraries (campus_id);

CREATE INDEX ON locations_libraries (campus_name);

CREATE INDEX ON locations_libraries (location_id);

CREATE INDEX ON locations_libraries (location_name);

CREATE INDEX ON locations_libraries (discovery_display_name);

CREATE INDEX ON locations_libraries (library_id);

CREATE INDEX ON locations_libraries (library_name);

CREATE INDEX ON locations_libraries (institution_id);

CREATE INDEX ON locations_libraries (institution_name);

VACUUM ANALYZE locations_libraries;
