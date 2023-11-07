-- Create derived table that combines institution, campus, library, and location information

DROP TABLE IF EXISTS locations_libraries;

CREATE TABLE locations_libraries AS
SELECT
    inventory_campuses.id AS campus_id,
    inventory_campuses.name AS campus_name,
    inventory_campuses.code AS campus_code,
    inventory_locations.id AS location_id,
    inventory_locations.name AS location_name,
    inventory_locations.code AS location_code,
    inventory_locations.discovery_display_name AS discovery_display_name,
    inventory_libraries.id AS library_id,
    inventory_libraries.name AS library_name,
    inventory_libraries.code AS library_code,
    inventory_institutions.id AS institution_id,
    inventory_institutions.name AS institution_name,
    inventory_institutions.code AS institution_code
FROM
    inventory_campuses
    JOIN inventory_locations ON inventory_campuses.id = inventory_locations.campus_id
    JOIN inventory_institutions ON inventory_locations.institution_id = inventory_institutions.id
    JOIN inventory_libraries ON inventory_locations.library_id = inventory_libraries.id;

