DROP TABLE IF EXISTS circulation_loan_history;

CREATE TABLE circulation_loan_history AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'createdDate')::timestamptz AS created_date,
    jsonb_extract_path_text(jsonb, 'operation')::varchar(65535) AS operation,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_circulation.audit_loan;

ALTER TABLE circulation_loan_history ADD PRIMARY KEY (id);

CREATE INDEX ON circulation_loan_history (created_date);

CREATE INDEX ON circulation_loan_history (operation);

VACUUM ANALYZE circulation_loan_history;
