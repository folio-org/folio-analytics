DROP TABLE IF EXISTS circulation_request_preference;

CREATE TABLE circulation_request_preference AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'defaultServicePointId')::varchar(36) AS default_service_point_id,
    jsonb_extract_path_text(jsonb, 'delivery')::boolean AS delivery,
    jsonb_extract_path_text(jsonb, 'fulfillment')::varchar(65535) AS fulfillment,
    jsonb_extract_path_text(jsonb, 'holdShelf')::boolean AS hold_shelf,
    jsonb_extract_path_text(jsonb, 'userId')::varchar(36) AS user_id,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_circulation.user_request_preference;

ALTER TABLE circulation_request_preference ADD PRIMARY KEY (id);

CREATE INDEX ON circulation_request_preference (default_service_point_id);

CREATE INDEX ON circulation_request_preference (delivery);

CREATE INDEX ON circulation_request_preference (fulfillment);

CREATE INDEX ON circulation_request_preference (hold_shelf);

CREATE INDEX ON circulation_request_preference (user_id);

