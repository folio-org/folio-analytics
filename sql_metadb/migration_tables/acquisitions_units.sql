DROP TABLE IF EXISTS acquisitions_units;

CREATE TABLE acquisitions_units AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'isDeleted')::boolean AS is_deleted,
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_extract_path_text(jsonb, 'protectCreate')::boolean AS protect_create,
    jsonb_extract_path_text(jsonb, 'protectDelete')::boolean AS protect_delete,
    jsonb_extract_path_text(jsonb, 'protectRead')::boolean AS protect_read,
    jsonb_extract_path_text(jsonb, 'protectUpdate')::boolean AS protect_update,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_orders.acquisitions_unit;

