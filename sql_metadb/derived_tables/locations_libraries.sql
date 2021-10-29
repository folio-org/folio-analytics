DROP TABLE IF EXISTS folio_derived.locations_libraries;

CREATE TABLE folio_derived.locations_libraries AS
SELECT
    cmp.id AS campus_id,
    json_extract_path_text(cmp.jsonb, 'name') AS campus_name,
    loc.id AS location_id,
    json_extract_path_text(loc.jsonb, 'name') AS location_name,
    json_extract_path_text(loc.jsonb, 'discoveryDisplayName') AS discovery_display_name,
    lib.id AS library_id,
    json_extract_path_text(lib.jsonb, 'name') AS library_name,
    inst.id AS institution_id,
    json_extract_path_text(inst.jsonb, 'name') AS institution_name
FROM
    folio_inventory.loccampus AS cmp
    JOIN folio_inventory.location AS loc ON cmp.id = loc.campusid
    JOIN folio_inventory.locinstitution AS inst ON loc.institutionid = inst.id
    JOIN folio_inventory.loclibrary AS lib ON loc.libraryid = lib.id;

CREATE INDEX ON folio_derived.locations_libraries (campus_id);

CREATE INDEX ON folio_derived.locations_libraries (campus_name);

CREATE INDEX ON folio_derived.locations_libraries (location_id);

CREATE INDEX ON folio_derived.locations_libraries (location_name);

CREATE INDEX ON folio_derived.locations_libraries (discovery_display_name);

CREATE INDEX ON folio_derived.locations_libraries (library_id);

CREATE INDEX ON folio_derived.locations_libraries (library_name);

CREATE INDEX ON folio_derived.locations_libraries (institution_id);

CREATE INDEX ON folio_derived.locations_libraries (institution_name);

