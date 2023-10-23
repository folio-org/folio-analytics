DROP TABLE IF EXISTS inventory_service_points_users;

CREATE TABLE inventory_service_points_users AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'defaultServicePointId')::varchar(36) AS default_service_point_id,
    jsonb_extract_path_text(jsonb, 'userId')::varchar(36) AS user_id,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_inventory.service_point_user;

