--metadb:table finance_funds

-- This derived table shows data of the funds from the finance app,
-- including associated data from budgets, ledgers and fiscal years.

DROP TABLE IF EXISTS finance_funds;

CREATE TABLE finance_funds AS
SELECT
    fiscal_year.id AS fiscal_year_id,
    jsonb_extract_path_text(fiscal_year.jsonb, 'code') AS fiscal_year_code,
    jsonb_extract_path_text(fiscal_year.jsonb, 'name') AS fiscal_year_name,
    jsonb_extract_path_text(fiscal_year.jsonb, 'periodStart')::timestamptz AS fiscal_year_period_start,
    jsonb_extract_path_text(fiscal_year.jsonb, 'periodEnd')::timestamptz  AS fiscal_year_period_end,
    jsonb_extract_path_text(fiscal_year.jsonb, 'description') AS fiscal_year_description,
    budget.id AS budget_id,
    jsonb_extract_path_text(budget.jsonb, 'name') AS budget_name,
    jsonb_extract_path_text(budget.jsonb, 'budgetStatus') AS budget_status,
    fund.id AS fund_id,
    jsonb_extract_path_text(fund.jsonb, 'code') AS fund_code,
    jsonb_extract_path_text(fund.jsonb, 'name') AS fund_name,
    jsonb_extract_path_text(fund.jsonb, 'fundStatus') AS fund_status,
    jsonb_extract_path_text(fund.jsonb, 'description') AS fund_description,
    jsonb_extract_path_text(fund.jsonb, 'fundTypeId')::uuid AS fund_type_id,
    jsonb_extract_path_text(fund_type.jsonb, 'name') AS fund_type_name,
    ledger.id AS ledger_id,
    jsonb_extract_path_text(ledger.jsonb, 'code') AS ledger_code,
    jsonb_extract_path_text(ledger.jsonb, 'name') AS ledger_name,
    jsonb_extract_path_text(ledger.jsonb, 'ledgerStatus') AS ledger_status,
    jsonb_extract_path_text(ledger.jsonb, 'description') AS ledger_description
FROM
    folio_finance.fiscal_year
    LEFT JOIN folio_finance.budget ON budget.fiscalyearid = fiscal_year.id
    LEFT JOIN folio_finance.fund ON fund.id = budget.fundid
    LEFT JOIN folio_finance.fund_type ON fund_type.id = fund.fundtypeid
    LEFT JOIN folio_finance.ledger ON ledger.id = fund.ledgerid;

CREATE INDEX ON finance_funds (fiscal_year_id);

CREATE INDEX ON finance_funds (fiscal_year_code);

CREATE INDEX ON finance_funds (fiscal_year_name);

CREATE INDEX ON finance_funds (fiscal_year_period_start);

CREATE INDEX ON finance_funds (fiscal_year_period_end);

CREATE INDEX ON finance_funds (fiscal_year_description);

CREATE INDEX ON finance_funds (budget_id);

CREATE INDEX ON finance_funds (budget_name);

CREATE INDEX ON finance_funds (budget_status);

CREATE INDEX ON finance_funds (fund_id);

CREATE INDEX ON finance_funds (fund_code);

CREATE INDEX ON finance_funds (fund_name);

CREATE INDEX ON finance_funds (fund_status);

CREATE INDEX ON finance_funds (fund_description);

CREATE INDEX ON finance_funds (fund_type_id);

CREATE INDEX ON finance_funds (fund_type_name);

CREATE INDEX ON finance_funds (ledger_id);

CREATE INDEX ON finance_funds (ledger_code);

CREATE INDEX ON finance_funds (ledger_name);

CREATE INDEX ON finance_funds (ledger_status);

CREATE INDEX ON finance_funds (ledger_description);

COMMENT ON COLUMN finance_funds.fiscal_year_id IS 'UUID of the fiscal year record';

COMMENT ON COLUMN finance_funds.fiscal_year_code IS 'The code of the fiscal year';

COMMENT ON COLUMN finance_funds.fiscal_year_name IS 'The name of the fiscal year';

COMMENT ON COLUMN finance_funds.fiscal_year_period_start IS 'The start date of the fiscal year';

COMMENT ON COLUMN finance_funds.fiscal_year_period_end IS 'The end date of the fiscal year';

COMMENT ON COLUMN finance_funds.fiscal_year_description IS 'The description of the fiscal year';

COMMENT ON COLUMN finance_funds.budget_id IS 'UUID of this budget';

COMMENT ON COLUMN finance_funds.budget_name IS 'The name of the budget';

COMMENT ON COLUMN finance_funds.budget_status IS 'The status of the budget';

COMMENT ON COLUMN finance_funds.fund_id IS 'UUID of this fund';

COMMENT ON COLUMN finance_funds.fund_code IS 'A unique code associated with the fund';

COMMENT ON COLUMN finance_funds.fund_name IS 'The name of this fund';

COMMENT ON COLUMN finance_funds.fund_status IS 'The current status of this fund';

COMMENT ON COLUMN finance_funds.fund_description IS 'The description of this fund';

COMMENT ON COLUMN finance_funds.fund_type_id IS 'UUID of the fund type associated with this fund';

COMMENT ON COLUMN finance_funds.fund_type_name IS 'Name of fund type';

COMMENT ON COLUMN finance_funds.ledger_id IS 'UUID of this ledger';

COMMENT ON COLUMN finance_funds.ledger_code IS 'The code for the ledger';

COMMENT ON COLUMN finance_funds.ledger_name IS 'The name of the ledger';

COMMENT ON COLUMN finance_funds.ledger_status IS 'The status of the ledger';

COMMENT ON COLUMN finance_funds.ledger_description IS 'The description of the ledger';

VACUUM ANALYZE finance_funds;
