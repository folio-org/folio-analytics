DROP TABLE IF EXISTS inventory_locations;

CREATE TABLE inventory_locations AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'campusId')::varchar(36) AS campus_id,
    jsonb_extract_path_text(jsonb, 'code')::varchar(65535) AS code,
    jsonb_extract_path_text(jsonb, 'description')::varchar(65535) AS description,
    jsonb_extract_path_text(jsonb, 'discoveryDisplayName')::varchar(65535) AS discovery_display_name,
    jsonb_extract_path_text(jsonb, 'institutionId')::varchar(36) AS institution_id,
    jsonb_extract_path_text(jsonb, 'isActive')::boolean AS is_active,
    jsonb_extract_path_text(jsonb, 'libraryId')::varchar(36) AS library_id,
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_extract_path_text(jsonb, 'primaryServicePoint')::varchar(36) AS primary_service_point,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_inventory.location;

