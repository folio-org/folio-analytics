DROP TABLE IF EXISTS feesfines_owners;

CREATE TABLE feesfines_owners AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'owner')::varchar(65535) AS owner,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_feesfines.owners;

ALTER TABLE feesfines_owners ADD PRIMARY KEY (id);

CREATE INDEX ON feesfines_owners (owner);

