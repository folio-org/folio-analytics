DROP TABLE IF EXISTS finance_fiscal_years;

CREATE TABLE finance_fiscal_years AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'code')::varchar(65535) AS code,
    jsonb_extract_path_text(jsonb, 'currency')::varchar(65535) AS currency,
    jsonb_extract_path_text(jsonb, 'description')::varchar(65535) AS description,
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_extract_path_text(jsonb, 'periodEnd')::timestamptz AS period_end,
    jsonb_extract_path_text(jsonb, 'periodStart')::timestamptz AS period_start,
    jsonb_extract_path_text(jsonb, 'series')::varchar(65535) AS series,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_finance.fiscal_year;

