DROP TABLE IF EXISTS feesfines_comments;

CREATE TABLE feesfines_comments AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'paid')::boolean AS paid,
    jsonb_extract_path_text(jsonb, 'refunded')::boolean AS refunded,
    jsonb_extract_path_text(jsonb, 'transferredManually')::boolean AS transferred_manually,
    jsonb_extract_path_text(jsonb, 'waived')::boolean AS waived,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_feesfines.comments;

ALTER TABLE feesfines_comments ADD PRIMARY KEY (id);

CREATE INDEX ON feesfines_comments (paid);

CREATE INDEX ON feesfines_comments (refunded);

CREATE INDEX ON feesfines_comments (transferred_manually);

CREATE INDEX ON feesfines_comments (waived);

VACUUM ANALYZE feesfines_comments;
