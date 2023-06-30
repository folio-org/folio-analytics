DROP TABLE IF EXISTS circulation_check_ins;

CREATE TABLE circulation_check_ins AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'itemId')::varchar(36) AS item_id,
    jsonb_extract_path_text(jsonb, 'itemLocationId')::varchar(36) AS item_location_id,
    jsonb_extract_path_text(jsonb, 'itemStatusPriorToCheckIn')::varchar(65535) AS item_status_prior_to_check_in,
    jsonb_extract_path_text(jsonb, 'occurredDateTime')::timestamptz AS occurred_date_time,
    jsonb_extract_path_text(jsonb, 'performedByUserId')::varchar(36) AS performed_by_user_id,
    jsonb_extract_path_text(jsonb, 'requestQueueSize')::bigint AS request_queue_size,
    jsonb_extract_path_text(jsonb, 'servicePointId')::varchar(36) AS service_point_id,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_circulation.check_in;

