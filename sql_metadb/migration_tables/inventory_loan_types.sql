DROP TABLE IF EXISTS inventory_loan_types;

CREATE TABLE inventory_loan_types AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_inventory.loan_type;

ALTER TABLE inventory_loan_types ADD PRIMARY KEY (id);

CREATE INDEX ON inventory_loan_types (name);

VACUUM ANALYZE inventory_loan_types;
