DROP TABLE IF EXISTS srs_marc;

CREATE TABLE srs_marc AS
SELECT
    id::varchar(36),
    jsonb_pretty(content)::json AS data
FROM
    folio_source_record.marc_records_lb;

