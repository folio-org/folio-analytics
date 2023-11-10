DROP TABLE IF EXISTS circulation_loan_policies;

CREATE TABLE circulation_loan_policies AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'description')::varchar(65535) AS description,
    jsonb_extract_path_text(jsonb, 'loanable')::boolean AS loanable,
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_extract_path_text(jsonb, 'renewable')::boolean AS renewable,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_circulation.loan_policy;

