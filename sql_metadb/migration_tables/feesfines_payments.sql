DROP TABLE IF EXISTS feesfines_payments;

CREATE TABLE feesfines_payments AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'allowedRefundMethod')::boolean AS allowed_refund_method,
    jsonb_extract_path_text(jsonb, 'nameMethod')::varchar(65535) AS name_method,
    jsonb_extract_path_text(jsonb, 'ownerId')::varchar(36) AS owner_id,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_feesfines.payments;

ALTER TABLE feesfines_payments ADD PRIMARY KEY (id);

CREATE INDEX ON feesfines_payments (allowed_refund_method);

CREATE INDEX ON feesfines_payments (name_method);

CREATE INDEX ON feesfines_payments (owner_id);

VACUUM ANALYZE feesfines_payments;
