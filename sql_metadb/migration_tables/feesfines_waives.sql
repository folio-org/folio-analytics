DROP TABLE IF EXISTS feesfines_waives;

CREATE TABLE feesfines_waives AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'nameReason')::varchar(65535) AS name_reason,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_feesfines.refunds;

ALTER TABLE feesfines_waives ADD PRIMARY KEY (id);

CREATE INDEX ON feesfines_waives (name_reason);

VACUUM ANALYZE feesfines_waives;
