DROP TABLE IF EXISTS feesfines_feefines;

CREATE TABLE feesfines_feefines AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'automatic')::boolean AS automatic,
    jsonb_extract_path_text(jsonb, 'feeFineType')::varchar(65535) AS fee_fine_type,
    jsonb_extract_path_text(jsonb, 'ownerId')::varchar(36) AS owner_id,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_feesfines.feefines;

