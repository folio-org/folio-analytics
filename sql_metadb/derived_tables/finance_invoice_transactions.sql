-- Create a derived table of fund distribution in invoices.
-- The derived table contains the information on the fund distribution
-- from the invoices app as well as from the transactions system
-- table.

DROP TABLE IF EXISTS finance_invoice_transactions;

CREATE TABLE finance_invoice_transactions AS
WITH invoice AS (
    SELECT
        invoices.id AS invoice_id,
        jsonb_extract_path_text(invoices.jsonb, 'folioInvoiceNo') AS folio_invoice_number,
        jsonb_extract_path_text(invoices.jsonb, 'vendorInvoiceNo') AS vendor_invoice_number,
        jsonb_extract_path_text(invoices.jsonb, 'invoiceDate')::timestamptz AS invoice_date,
        jsonb_extract_path_text(invoices.jsonb, 'currency') AS invoice_currency,
        jsonb_extract_path_text(invoices.jsonb, 'exchangeRate')::numeric(19,14) AS invoice_exchange_rate,
        jsonb_extract_path_text(invoices.jsonb, 'status') AS invoice_status,
        invoice_lines.id AS invoice_line_id,
        jsonb_extract_path_text(invoice_lines.jsonb, 'total')::numeric(19,4) AS invoice_line_total,
        jsonb_extract_path_text(jsonb_array_elements(invoice_lines.jsonb->'fundDistributions'), 'fundId')::uuid AS invoice_line_fund_id,
        jsonb_extract_path_text(jsonb_array_elements(invoice_lines.jsonb->'fundDistributions'), 'value')::numeric(19,4) AS invoice_line_distribution_value,
        jsonb_extract_path_text(jsonb_array_elements(invoice_lines.jsonb->'fundDistributions'), 'distributionType') AS invoice_line_distribution_type,
        organizations.id AS vendor_id,
        jsonb_extract_path_text(organizations.jsonb, 'name') AS vendor_name
    FROM
        folio_invoice.invoice_lines
        LEFT JOIN folio_invoice.invoices ON invoices.id = invoice_lines.invoiceid
        LEFT JOIN folio_organizations.organizations ON jsonb_extract_path_text(invoices.jsonb, 'vendorId')::uuid = organizations.id
),
finance AS (
    SELECT
        fiscal_year.id AS fiscal_year_id,
        jsonb_extract_path_text(fiscal_year.jsonb, 'code') AS fiscal_year,
        ledger.id AS ledger_id,
        jsonb_extract_path_text(ledger.jsonb, 'name') AS ledger_name,
        budget.id AS budget_id,
        jsonb_extract_path_text(budget.jsonb, 'name') AS budget_name,
        fund.id AS fund_id,
        jsonb_extract_path_text(fund.jsonb, 'code') AS fund_code
    FROM
        folio_finance.fiscal_year
        LEFT JOIN folio_finance.ledger ON ledger.fiscalyearoneid = fiscal_year.id
        LEFT JOIN folio_finance.fund ON fund.ledgerid = ledger.id
        LEFT JOIN folio_finance.budget ON budget.fundid = fund.id AND budget.fiscalyearid = fiscal_year.id
),
transactions AS (
    SELECT
        transaction.id AS transaction_id,
        jsonb_extract_path_text(transaction.jsonb, 'fromFundId')::uuid AS from_fund_id,
        jsonb_extract_path_text(transaction.jsonb, 'amount')::numeric(19,4) AS transaction_amount,
        jsonb_extract_path_text(transaction.jsonb, 'currency') AS transaction_currency,
        jsonb_extract_path_text(transaction.jsonb, 'sourceInvoiceLineId')::uuid AS source_invoice_line_id
    FROM
        folio_finance.transaction
)
SELECT
    invoice.invoice_id,
    invoice.folio_invoice_number,
    invoice.vendor_id,
    invoice.vendor_name,
    invoice.vendor_invoice_number,
    invoice.invoice_date,
    invoice.invoice_status,
    invoice.invoice_line_id,
    invoice.invoice_line_total,
    invoice.invoice_currency,
    invoice.invoice_line_distribution_value,
    invoice.invoice_line_distribution_type,
    finance_invoice.fiscal_year_id AS invoice_line_fiscal_year_id,
    finance_invoice.fiscal_year AS invoice_line_fiscal_year,
    finance_invoice.ledger_id AS invoice_line_ledger_id,
    finance_invoice.ledger_name AS invoice_line_ledger_name,
    finance_invoice.budget_id AS invoice_line_budget_id,
    finance_invoice.budget_name AS invoice_line_budget_name,
    finance_invoice.fund_id AS invoice_line_fund_id,
    finance_invoice.fund_code AS invoice_line_fund_code,
    invoice.invoice_exchange_rate,
    transactions_invoice.transaction_id AS invoice_line_transaction_id,
    transactions_invoice.transaction_amount AS invoice_line_transaction_amount,
    transactions_invoice.transaction_currency AS invoice_line_transaction_currency
FROM
    invoice
    LEFT JOIN finance AS finance_invoice ON finance_invoice.fund_id = invoice.invoice_line_fund_id
    LEFT JOIN transactions AS transactions_invoice ON transactions_invoice.source_invoice_line_id = invoice.invoice_line_id
        AND transactions_invoice.from_fund_id = invoice.invoice_line_fund_id;

CREATE INDEX ON finance_invoice_transactions (invoice_id);

CREATE INDEX ON finance_invoice_transactions (folio_invoice_number);

CREATE INDEX ON finance_invoice_transactions (vendor_id);

CREATE INDEX ON finance_invoice_transactions (vendor_name);

CREATE INDEX ON finance_invoice_transactions (vendor_invoice_number);

CREATE INDEX ON finance_invoice_transactions (invoice_date);

CREATE INDEX ON finance_invoice_transactions (invoice_status);

CREATE INDEX ON finance_invoice_transactions (invoice_line_id);

CREATE INDEX ON finance_invoice_transactions (invoice_line_total);

CREATE INDEX ON finance_invoice_transactions (invoice_currency);

CREATE INDEX ON finance_invoice_transactions (invoice_line_distribution_value);

CREATE INDEX ON finance_invoice_transactions (invoice_line_distribution_type);

CREATE INDEX ON finance_invoice_transactions (invoice_line_fiscal_year_id);

CREATE INDEX ON finance_invoice_transactions (invoice_line_fiscal_year);

CREATE INDEX ON finance_invoice_transactions (invoice_line_ledger_id);

CREATE INDEX ON finance_invoice_transactions (invoice_line_ledger_name);

CREATE INDEX ON finance_invoice_transactions (invoice_line_budget_id);

CREATE INDEX ON finance_invoice_transactions (invoice_line_budget_name);

CREATE INDEX ON finance_invoice_transactions (invoice_line_fund_id);

CREATE INDEX ON finance_invoice_transactions (invoice_line_fund_code);

CREATE INDEX ON finance_invoice_transactions (invoice_exchange_rate);

CREATE INDEX ON finance_invoice_transactions (invoice_line_transaction_id);

CREATE INDEX ON finance_invoice_transactions (invoice_line_transaction_amount);

CREATE INDEX ON finance_invoice_transactions (invoice_line_transaction_currency);

VACUUM ANALYZE finance_invoice_transactions;
