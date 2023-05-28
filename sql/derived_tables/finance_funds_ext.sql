-- This derived table shows data of the funds from the finance app,
-- including associated data from budgets, ledgers and fiscal years.

DROP TABLE IF EXISTS finance_funds_ext;

CREATE TABLE finance_funds_ext AS
SELECT
    fiscal_year.id AS fiscal_year_id,
    json_extract_path_text(fiscal_year.data, 'code') AS fiscal_year_code,
    json_extract_path_text(fiscal_year.data, 'name') AS fiscal_year_name,
    json_extract_path_text(fiscal_year.data, 'periodStart')::timestamptz AS fiscal_year_period_start,
    json_extract_path_text(fiscal_year.data, 'periodEnd')::timestamptz  AS fiscal_year_period_end,
    json_extract_path_text(fiscal_year.data, 'description') AS fiscal_year_description,
    budget.id AS budget_id,
    json_extract_path_text(budget.data, 'name') AS budget_name,
    json_extract_path_text(budget.data, 'budgetStatus') AS budget_status,
    fund.id AS fund_id,
    json_extract_path_text(fund.data, 'code') AS fund_code,
    json_extract_path_text(fund.data, 'name') AS fund_name,
    json_extract_path_text(fund.data, 'fundStatus') AS fund_status,
    json_extract_path_text(fund.data, 'description') AS fund_description,
    json_extract_path_text(fund.data, 'fundTypeId') AS fund_type_id,
    json_extract_path_text(fund_type.data, 'name') AS fund_type_name,
    ledger.id AS ledger_id,
    json_extract_path_text(ledger.data, 'code') AS ledger_code,
    json_extract_path_text(ledger.data, 'name') AS ledger_name,
    json_extract_path_text(ledger.data, 'ledgerStatus') AS ledger_status,
    json_extract_path_text(ledger.data, 'description') AS ledger_description
FROM
    finance_fiscal_years AS fiscal_year
    LEFT JOIN finance_budgets AS budget ON budget.fiscal_year_id = fiscal_year.id
    LEFT JOIN finance_funds AS fund ON fund.id = budget.fund_id
    LEFT JOIN finance_fund_types AS fund_type ON fund_type.id = fund.fund_type_id
    LEFT JOIN finance_ledgers AS ledger ON ledger.id = fund.ledger_id;

COMMENT ON COLUMN finance_funds_ext.fiscal_year_id IS 'UUID of the fiscal year record';

COMMENT ON COLUMN finance_funds_ext.fiscal_year_code IS 'The code of the fiscal year';

COMMENT ON COLUMN finance_funds_ext.fiscal_year_name IS 'The name of the fiscal year';

COMMENT ON COLUMN finance_funds_ext.fiscal_year_period_start IS 'The start date of the fiscal year';

COMMENT ON COLUMN finance_funds_ext.fiscal_year_period_end IS 'The end date of the fiscal year';

COMMENT ON COLUMN finance_funds_ext.fiscal_year_description IS 'The description of the fiscal year';

COMMENT ON COLUMN finance_funds_ext.budget_id IS 'UUID of this budget';

COMMENT ON COLUMN finance_funds_ext.budget_name IS 'The name of the budget';

COMMENT ON COLUMN finance_funds_ext.budget_status IS 'The status of the budget';

COMMENT ON COLUMN finance_funds_ext.fund_id IS 'UUID of this fund';

COMMENT ON COLUMN finance_funds_ext.fund_code IS 'A unique code associated with the fund';

COMMENT ON COLUMN finance_funds_ext.fund_name IS 'The name of this fund';

COMMENT ON COLUMN finance_funds_ext.fund_status IS 'The current status of this fund';

COMMENT ON COLUMN finance_funds_ext.fund_description IS 'The description of this fund';

COMMENT ON COLUMN finance_funds_ext.fund_type_id IS 'UUID of the fund type associated with this fund';

COMMENT ON COLUMN finance_funds_ext.fund_type_name IS 'Name of fund type';

COMMENT ON COLUMN finance_funds_ext.ledger_id IS 'UUID of this ledger';

COMMENT ON COLUMN finance_funds_ext.ledger_code IS 'The code for the ledger';

COMMENT ON COLUMN finance_funds_ext.ledger_name IS 'The name of the ledger';

COMMENT ON COLUMN finance_funds_ext.ledger_status IS 'The status of the ledger';

COMMENT ON COLUMN finance_funds_ext.ledger_description IS 'The description of the ledger';

