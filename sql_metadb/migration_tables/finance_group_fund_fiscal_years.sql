DROP TABLE IF EXISTS finance_group_fund_fiscal_years;

CREATE TABLE finance_group_fund_fiscal_years AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'budgetId')::varchar(36) AS budget_id,
    jsonb_extract_path_text(jsonb, 'fiscalYearId')::varchar(36) AS fiscal_year_id,
    jsonb_extract_path_text(jsonb, 'fundId')::varchar(36) AS fund_id,
    jsonb_extract_path_text(jsonb, 'groupId')::varchar(36) AS group_id,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_finance.group_fund_fiscal_year;

ALTER TABLE finance_group_fund_fiscal_years ADD PRIMARY KEY (id);

CREATE INDEX ON finance_group_fund_fiscal_years (budget_id);

CREATE INDEX ON finance_group_fund_fiscal_years (fiscal_year_id);

CREATE INDEX ON finance_group_fund_fiscal_years (fund_id);

CREATE INDEX ON finance_group_fund_fiscal_years (group_id);

VACUUM ANALYZE finance_group_fund_fiscal_years;
