DROP TABLE IF EXISTS finance_fund_types;

CREATE TABLE finance_fund_types AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_finance.fund_type;

ALTER TABLE finance_fund_types ADD PRIMARY KEY (id);

CREATE INDEX ON finance_fund_types (name);

