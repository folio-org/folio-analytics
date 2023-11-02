--metadb:table finance_invoice_transactions
--metadb:require folio_finance.expense_class__t.id uuid
--metadb:require folio_finance.expense_class__t.code text
--metadb:require folio_finance.expense_class__t.name text
--metadb:require folio_finance.expense_class__t.external_account_number_ext text

-- Create a derived table of fund distribution in invoices.
-- The derived table contains the information on the fund distribution
-- from the invoices app as well as from the transactions system
-- table.

DROP TABLE IF EXISTS finance_invoice_transactions;

CREATE TABLE finance_invoice_transactions AS
WITH invoice_lines_fund_distribution AS (
    SELECT 
        invoice_lines.id AS invoice_line_id,
        jsonb_extract_path_text(invoice_lines.jsonb, 'total')::numeric(19,4) AS invoice_line_total,
        jsonb_extract_path_text(jsonb_array_elements(jsonb_extract_path(invoice_lines.jsonb, 'fundDistributions')), 'fundId')::uuid AS invoice_line_fund_id,
        jsonb_extract_path_text(jsonb_array_elements(jsonb_extract_path(invoice_lines.jsonb, 'fundDistributions')), 'value')::numeric(19,4) AS invoice_line_distribution_value,
        jsonb_extract_path_text(jsonb_array_elements(jsonb_extract_path(invoice_lines.jsonb, 'fundDistributions')), 'distributionType') AS invoice_line_distribution_type,
        jsonb_extract_path_text(jsonb_array_elements(jsonb_extract_path(invoice_lines.jsonb, 'fundDistributions')), 'expenseClassId') :: UUID AS invoice_line_distribution_expense_class_id
    FROM 
        folio_invoice.invoice_lines
),
invoice_vendors AS (
    SELECT
        invoices__t.id AS invoice_id,
        organizations__t.name AS invoice_vendor_name
    FROM 
        folio_invoice.invoices__t
        INNER JOIN folio_organizations.organizations__t ON organizations__t.id = invoices__t.vendor_id 
),
finance AS (
    SELECT
        fiscal_year__t.id AS fiscal_year_id,
        fiscal_year__t.code AS fiscal_year,
        ledger__t.id AS ledger_id,
        ledger__t.name AS ledger_name,
        budget__t.id AS budget_id,
        budget__t.name AS budget_name,
        fund__t.id AS fund_id,
        fund__t.code AS fund_code
    FROM            
        folio_finance.fiscal_year__t
        LEFT JOIN folio_finance.budget__t ON budget__t.fiscal_year_id = fiscal_year__t.id
        LEFT JOIN folio_finance.fund__t ON fund__t.id = budget__t.fund_id
        LEFT JOIN folio_finance.ledger__t ON ledger__t.id = fund__t.ledger_id
),
transactions AS (
    SELECT
        transaction__t.id AS transaction_id,
        transaction__t.from_fund_id AS from_fund_id,
        transaction__t.amount AS transaction_amount,
        transaction__t.currency AS transaction_currency,
        transaction__t.fiscal_year_id,
        transaction__t.source_invoice_line_id AS source_invoice_line_id,
        transaction__t.expense_class_id AS transaction_expense_class_id,
        expense_class__t.code AS expense_class_code,
        expense_class__t.name AS expense_class_name,
        expense_class__t.external_account_number_ext
    FROM
        folio_finance.transaction__t
        LEFT JOIN folio_finance.expense_class__t ON expense_class__t.id = transaction__t.expense_class_id
)
SELECT
    invoices__t.id AS invoice_id,
    invoices__t.status AS invoice_status,
    invoices__t.folio_invoice_no AS folio_invoice_number,
    invoices__t.vendor_id,
    invoice_vendors.invoice_vendor_name AS vendor_name,
    invoices__t.vendor_invoice_no AS vendor_invoice_number,
    invoices__t.invoice_date,
    invoice_lines__t.id AS invoice_line_id,
    invoice_lines__t.total AS invoice_line_total,
    invoices__t.currency AS invoice_currency,
    invoice_lines_fund_distribution.invoice_line_distribution_value,
    invoice_lines_fund_distribution.invoice_line_distribution_type,
    invoice_lines_fund_distribution.invoice_line_fund_id,
    inv_line_fund.code AS invoice_line_fund_code,
    inv_line_expense_class.id AS invoice_line_expense_class_id,
    inv_line_expense_class.code AS invoice_line_expense_class_code,
    inv_line_expense_class.name AS invoice_line_expense_class_name,
    inv_line_expense_class.external_account_number_ext,
    invoices__t.exchange_rate,
    transactions.transaction_id,
    transactions.transaction_amount,
    transactions.transaction_currency,
    finance.fund_id AS transaction_fund_id,
    finance.fund_code AS transaction_fund_code,
    finance.fiscal_year_id,
    finance.fiscal_year,
    finance.ledger_id,
    finance.ledger_name,
    finance.budget_id,
    finance.budget_name,        
    transactions.transaction_expense_class_id,
    transactions.expense_class_code AS transactions_expense_class_code,
    transactions.expense_class_name AS transactions_expense_class_name,
    transactions.external_account_number_ext AS transactions_external_account_number_ext
FROM
    folio_invoice.invoices__t
    LEFT JOIN folio_invoice.invoice_lines__t ON invoice_lines__t.invoice_id = invoices__t.id
    LEFT JOIN invoice_lines_fund_distribution ON invoice_lines_fund_distribution.invoice_line_id = invoice_lines__t.id
    LEFT JOIN folio_finance.expense_class__t AS inv_line_expense_class ON inv_line_expense_class.id = invoice_lines_fund_distribution.invoice_line_distribution_expense_class_id
    LEFT JOIN folio_finance.fund__t AS inv_line_fund ON inv_line_fund.id = invoice_lines_fund_distribution.invoice_line_fund_id
    LEFT JOIN invoice_vendors ON invoice_vendors.invoice_id = invoices__t.id    
    LEFT JOIN transactions ON transactions.source_invoice_line_id = invoice_lines__t.id
        AND transactions.from_fund_id = invoice_lines_fund_distribution.invoice_line_fund_id
    LEFT JOIN finance ON finance.fund_id = transactions.from_fund_id
        AND finance.fiscal_year_id = transactions.fiscal_year_id
WHERE 
    invoice_lines_fund_distribution.invoice_line_distribution_expense_class_id IS NULL
UNION 
SELECT
    invoices__t.id AS invoice_id,
    invoices__t.status AS invoice_status,
    invoices__t.folio_invoice_no AS folio_invoice_number,
    invoices__t.vendor_id,
    invoice_vendors.invoice_vendor_name AS vendor_name,
    invoices__t.vendor_invoice_no AS vendor_invoice_number,
    invoices__t.invoice_date,
    invoice_lines__t.id AS invoice_line_id,
    invoice_lines__t.total AS invoice_line_total,
    invoices__t.currency AS invoice_currency,
    invoice_lines_fund_distribution.invoice_line_distribution_value,
    invoice_lines_fund_distribution.invoice_line_distribution_type,
    invoice_lines_fund_distribution.invoice_line_fund_id,
    inv_line_fund.code AS invoice_line_fund_code,
    inv_line_expense_class.id AS invoice_line_expense_class_id,
    inv_line_expense_class.code AS invoice_line_expense_class_code,
    inv_line_expense_class.name AS invoice_line_expense_class_name,
    inv_line_expense_class.external_account_number_ext,
    invoices__t.exchange_rate,
    transactions.transaction_id,
    transactions.transaction_amount,
    transactions.transaction_currency,
    finance.fund_id AS transaction_fund_id,
    finance.fund_code AS transaction_fund_code,
    finance.fiscal_year_id,
    finance.fiscal_year,
    finance.ledger_id,
    finance.ledger_name,
    finance.budget_id,
    finance.budget_name,
    transactions.transaction_expense_class_id,
    transactions.expense_class_code AS transactions_expense_class_code,
    transactions.expense_class_name AS transactions_expense_class_name,
    transactions.external_account_number_ext AS transactions_external_account_number_ext
FROM
    folio_invoice.invoices__t
    LEFT JOIN folio_invoice.invoice_lines__t ON invoice_lines__t.invoice_id = invoices__t.id
    LEFT JOIN invoice_lines_fund_distribution ON invoice_lines_fund_distribution.invoice_line_id = invoice_lines__t.id
    LEFT JOIN folio_finance.expense_class__t AS inv_line_expense_class ON inv_line_expense_class.id = invoice_lines_fund_distribution.invoice_line_distribution_expense_class_id
    LEFT JOIN folio_finance.fund__t AS inv_line_fund ON inv_line_fund.id = invoice_lines_fund_distribution.invoice_line_fund_id
    LEFT JOIN invoice_vendors ON invoice_vendors.invoice_id = invoices__t.id    
    LEFT JOIN transactions ON transactions.source_invoice_line_id = invoice_lines__t.id
        AND transactions.from_fund_id = invoice_lines_fund_distribution.invoice_line_fund_id
        AND transactions.transaction_expense_class_id = invoice_lines_fund_distribution.invoice_line_distribution_expense_class_id
    LEFT JOIN finance ON finance.fund_id = transactions.from_fund_id
        AND finance.fiscal_year_id = transactions.fiscal_year_id
WHERE 
    invoice_lines_fund_distribution.invoice_line_distribution_expense_class_id IS NOT NULL    
;

COMMENT ON COLUMN finance_invoice_transactions.invoice_id IS 'UUID of the invoice';

COMMENT ON COLUMN finance_invoice_transactions.invoice_status IS 'Workflow status of the invoice';

COMMENT ON COLUMN finance_invoice_transactions.folio_invoice_number IS 'Invoice number in folio system';

COMMENT ON COLUMN finance_invoice_transactions.vendor_id IS 'UUID for vendor';

COMMENT ON COLUMN finance_invoice_transactions.vendor_name IS 'Name of vendor';

COMMENT ON COLUMN finance_invoice_transactions.vendor_invoice_number IS 'This is the number from the vendors invoice, which is different from the folio invoice number';

COMMENT ON COLUMN finance_invoice_transactions.invoice_date IS 'Invoice date';

COMMENT ON COLUMN finance_invoice_transactions.invoice_line_id IS 'UUID of the invoice line';

COMMENT ON COLUMN finance_invoice_transactions.invoice_line_total IS 'Total of each separate invoice line';

COMMENT ON COLUMN finance_invoice_transactions.invoice_currency IS 'Ideally this is the ISO code and not something the user defines';

COMMENT ON COLUMN finance_invoice_transactions.invoice_line_distribution_value IS 'The percentage of the cost to be applied to this fund';

COMMENT ON COLUMN finance_invoice_transactions.invoice_line_distribution_type IS 'Type of value (percentage or amount)';

COMMENT ON COLUMN finance_invoice_transactions.invoice_line_fund_id IS 'UUID of the fund associated with this fund distribution';

COMMENT ON COLUMN finance_invoice_transactions.invoice_line_fund_code IS 'Code of the fund';

COMMENT ON COLUMN finance_invoice_transactions.invoice_line_expense_class_id IS 'UUID of the expense class from the invoice line';

COMMENT ON COLUMN finance_invoice_transactions.invoice_line_expense_class_code IS 'Code of the expense class from the invoice line';

COMMENT ON COLUMN finance_invoice_transactions.invoice_line_expense_class_name IS 'Name of the expense class from the invoice line';

COMMENT ON COLUMN finance_invoice_transactions.external_account_number_ext IS 'An external account number extension';

COMMENT ON COLUMN finance_invoice_transactions.exchange_rate IS 'Exchange rate';

COMMENT ON COLUMN finance_invoice_transactions.transaction_id IS 'UUID of this transaction';

COMMENT ON COLUMN finance_invoice_transactions.transaction_amount IS 'The amount of this transaction';

COMMENT ON COLUMN finance_invoice_transactions.transaction_currency IS 'Currency code for this transaction - from the system currency';

COMMENT ON COLUMN finance_invoice_transactions.transaction_fund_id IS 'UUID of the fund associated with this transaction';

COMMENT ON COLUMN finance_invoice_transactions.transaction_fund_code IS 'Code of the fund associated with this transaction';

COMMENT ON COLUMN finance_invoice_transactions.fiscal_year_id IS 'UUID of the fiscal year';

COMMENT ON COLUMN finance_invoice_transactions.fiscal_year IS 'Code of the fiscal year';

COMMENT ON COLUMN finance_invoice_transactions.ledger_id IS 'UUID of the ledger';

COMMENT ON COLUMN finance_invoice_transactions.ledger_name IS 'Name of the ledger';

COMMENT ON COLUMN finance_invoice_transactions.budget_id IS 'UUID of the budget';

COMMENT ON COLUMN finance_invoice_transactions.budget_name IS 'Name of the budget';

COMMENT ON COLUMN finance_invoice_transactions.transaction_expense_class_id IS 'UUID of the expense class from the transaction';

COMMENT ON COLUMN finance_invoice_transactions.transactions_expense_class_code IS 'Code of the expense class from the transaction';

COMMENT ON COLUMN finance_invoice_transactions.transactions_expense_class_name IS 'Name of the expense class from the transaction';

COMMENT ON COLUMN finance_invoice_transactions.transactions_external_account_number_ext IS 'An external account number extension';
