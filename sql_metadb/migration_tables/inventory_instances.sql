DROP TABLE IF EXISTS inventory_instances;

CREATE TABLE inventory_instances AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, '_version')::bigint AS _version,
    jsonb_extract_path_text(jsonb, 'catalogedDate')::date AS cataloged_date,
    jsonb_extract_path_text(jsonb, 'discoverySuppress')::boolean AS discovery_suppress,
    jsonb_extract_path_text(jsonb, 'hrid')::varchar(65535) AS hrid,
    jsonb_extract_path_text(jsonb, 'indexTitle')::varchar(65535) AS index_title,
    jsonb_extract_path_text(jsonb, 'instanceTypeId')::varchar(36) AS instance_type_id,
    jsonb_extract_path_text(jsonb, 'modeOfIssuanceId')::varchar(36) AS mode_of_issuance_id,
    jsonb_extract_path_text(jsonb, 'previouslyHeld')::boolean AS previously_held,
    jsonb_extract_path_text(jsonb, 'source')::varchar(65535) AS source,
    jsonb_extract_path_text(jsonb, 'staffSuppress')::boolean AS staff_suppress,
    jsonb_extract_path_text(jsonb, 'statusId')::varchar(36) AS status_id,
    jsonb_extract_path_text(jsonb, 'statusUpdatedDate')::timestamptz AS status_updated_date,
    jsonb_extract_path_text(jsonb, 'title')::varchar(65535) AS title,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_inventory.instance;

