DROP TABLE IF EXISTS srs_error;

CREATE TABLE srs_error AS
SELECT
    id::varchar(36),
    description::varchar(65535),
    jsonb_pretty(content)::json AS data
FROM
    folio_source_record.error_records_lb;

