DROP TABLE IF EXISTS circulation_loan_policies;

CREATE TABLE circulation_loan_policies AS
SELECT
    id::varchar(36),
    (jsonb->>'description')::varchar AS description,
    (jsonb->>'loanable')::bool AS loanable,
    (jsonb->>'name')::varchar AS name,
    (jsonb->>'renewable')::bool AS renewable,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_circulation.loan_policy;

ALTER TABLE circulation_loan_policies ADD PRIMARY KEY (id);

CREATE INDEX ON circulation_loan_policies (description);

CREATE INDEX ON circulation_loan_policies (loanable);

CREATE INDEX ON circulation_loan_policies (name);

CREATE INDEX ON circulation_loan_policies (renewable);

VACUUM ANALYZE circulation_loan_policies;
