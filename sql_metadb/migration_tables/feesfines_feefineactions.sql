DROP TABLE IF EXISTS feesfines_feefineactions;

CREATE TABLE feesfines_feefineactions AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'accountId')::varchar(36) AS account_id,
    jsonb_extract_path_text(jsonb, 'amountAction')::numeric(12,2) AS amount_action,
    jsonb_extract_path_text(jsonb, 'balance')::numeric(12,2) AS balance,
    jsonb_extract_path_text(jsonb, 'comments')::varchar(65535) AS comments,
    jsonb_extract_path_text(jsonb, 'createdAt')::varchar(65535) AS created_at,
    jsonb_extract_path_text(jsonb, 'dateAction')::timestamptz AS date_action,
    jsonb_extract_path_text(jsonb, 'notify')::boolean AS notify,
    jsonb_extract_path_text(jsonb, 'paymentMethod')::varchar(65535) AS payment_method,
    jsonb_extract_path_text(jsonb, 'source')::varchar(65535) AS source,
    jsonb_extract_path_text(jsonb, 'transactionInformation')::varchar(65535) AS transaction_information,
    jsonb_extract_path_text(jsonb, 'typeAction')::varchar(65535) AS type_action,
    jsonb_extract_path_text(jsonb, 'userId')::varchar(36) AS user_id,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_feesfines.feefineactions;

ALTER TABLE feesfines_feefineactions ADD PRIMARY KEY (id);

CREATE INDEX ON feesfines_feefineactions (account_id);

CREATE INDEX ON feesfines_feefineactions (amount_action);

CREATE INDEX ON feesfines_feefineactions (balance);

CREATE INDEX ON feesfines_feefineactions (comments);

CREATE INDEX ON feesfines_feefineactions (created_at);

CREATE INDEX ON feesfines_feefineactions (date_action);

CREATE INDEX ON feesfines_feefineactions (notify);

CREATE INDEX ON feesfines_feefineactions (payment_method);

CREATE INDEX ON feesfines_feefineactions (source);

CREATE INDEX ON feesfines_feefineactions (transaction_information);

CREATE INDEX ON feesfines_feefineactions (type_action);

CREATE INDEX ON feesfines_feefineactions (user_id);

