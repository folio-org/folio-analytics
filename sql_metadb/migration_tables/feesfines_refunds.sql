DROP TABLE IF EXISTS feesfines_refunds;

CREATE TABLE feesfines_refunds AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'nameReason')::varchar(65535) AS name_reason,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_feesfines.refunds;

