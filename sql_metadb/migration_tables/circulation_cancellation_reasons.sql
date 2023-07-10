DROP TABLE IF EXISTS circulation_cancellation_reasons;

CREATE TABLE circulation_cancellation_reasons AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'description')::varchar(65535) AS description,
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_extract_path_text(jsonb, 'publicDescription')::varchar(65535) AS public_description,
    jsonb_extract_path_text(jsonb, 'requiresAdditionalInformation')::boolean AS requires_additional_information,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_circulation.cancellation_reason;

