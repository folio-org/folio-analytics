DROP TABLE IF EXISTS folio_derived.locations_libraries;

CREATE TABLE folio_derived.locations_libraries AS
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
    folio_inventory.loccampus_j AS cmp
    JOIN folio_inventory.location_j AS loc ON cmp.id = loc.campus_id
    JOIN folio_inventory.locinstitution_j AS inst ON loc.institution_id = inst.id
    JOIN folio_inventory.loclibrary_j AS lib ON loc.library_id = lib.id;

CREATE INDEX ON folio_derived.locations_libraries (campus_id);

CREATE INDEX ON folio_derived.locations_libraries (campus_name);

CREATE INDEX ON folio_derived.locations_libraries (location_id);

CREATE INDEX ON folio_derived.locations_libraries (location_name);

CREATE INDEX ON folio_derived.locations_libraries (discovery_display_name);

CREATE INDEX ON folio_derived.locations_libraries (library_id);

CREATE INDEX ON folio_derived.locations_libraries (library_name);

CREATE INDEX ON folio_derived.locations_libraries (institution_id);

CREATE INDEX ON folio_derived.locations_libraries (institution_name);

