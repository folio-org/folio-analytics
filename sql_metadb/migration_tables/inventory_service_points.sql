DROP TABLE IF EXISTS inventory_service_points;

CREATE TABLE inventory_service_points AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'code')::varchar(65535) AS code,
    jsonb_extract_path_text(jsonb, 'discoveryDisplayName')::varchar(65535) AS discovery_display_name,
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_extract_path_text(jsonb, 'pickupLocation')::boolean AS pickup_location,
    jsonb_extract_path_text(jsonb, 'shelvingLagTime')::bigint AS shelving_lag_time,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_inventory.service_point;

