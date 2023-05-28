DROP TABLE IF EXISTS finance_transaction_invoices;

-- Create a derived table that joins invoice and invoice_lines fields to transactions for expenditure reports in system currency
--
-- NOTE: effective_fund_id, effective_fund_name, effective_fund_code were derived from the set from_fund or to_fund as a convenient 
-- 		 way to get the effective fund
--
-- Tables included:
--   finance_transactions
--	 finance_budgets
--	 finance_funds
--   invoice_invoices
--   invoice_lines
CREATE TABLE finance_transaction_invoices AS
SELECT
    ft.id AS transaction_id,
    ft.amount AS transaction_amount,
    ft.currency AS transaction_currency,
    json_extract_path_text(ft.data, 'metadata', 'createdDate')::DATE AS transaction_created_date,
    json_extract_path_text(ft.data, 'metadata', 'updatedDate')::DATE AS transaction_updated_date,
    ft.description AS transaction_description,
    json_extract_path_text(ft.data, 'expenseClassId') AS transaction_expense_class_id,
    ft.fiscal_year_id AS transaction_fiscal_year_id,
    ft.from_fund_id AS transaction_from_fund_id,
    ff.name AS transaction_from_fund_name,
    ff.code AS transaction_from_fund_code,
    ft.to_fund_id AS transaction_to_fund_id,
    tf.name AS transaction_to_fund_name,
    tf.code AS transaction_to_fund_code,
    CASE WHEN ft.to_fund_id IS NULL THEN ft.from_fund_id ELSE ft.to_fund_id END AS effective_fund_id,
    CASE WHEN ff.name IS NULL THEN tf.name ELSE ff.name END AS effective_fund_name,
    CASE WHEN ff.code IS NULL THEN tf.code ELSE ff.code END AS effective_fund_code,
    fb.id AS transaction_from_budget_id,
    fb.name AS transaction_from_budget_name,
    json_extract_path_text(ft.data, 'sourceInvoiceId') AS invoice_id,
    json_extract_path_text(ft.data, 'sourceInvoiceLineId') AS invoice_line_id,
    ft.transaction_type AS transaction_type,
    json_extract_path_text(ii.data, 'invoiceDate') AS invoice_date,
    json_extract_path_text(ii.data, 'paymentDate') AS invoice_payment_date,
    json_extract_path_text(ii.data, 'exchangeRate') AS invoice_exchange_rate,
    json_extract_path_text(il.data, 'total') AS invoice_line_total,
    json_extract_path_text(ii.data, 'currency') AS invoice_currency,
    json_extract_path_text(il.data, 'poLineId') AS po_line_id,
    json_extract_path_text(ii.data, 'vendorId') AS invoice_vendor_id,
    oo.name AS invoice_vendor_name
FROM
    finance_transactions AS ft
    LEFT JOIN invoice_invoices AS ii ON json_extract_path_text(ft.data, 'sourceInvoiceId') = ii.id
    LEFT JOIN invoice_lines AS il ON json_extract_path_text(ft.data, 'sourceInvoiceLineId') = il.id
    LEFT JOIN finance_funds AS ff ON ft.from_fund_id = ff.id
    LEFT JOIN finance_funds AS tf ON ft.to_fund_id = tf.id
    LEFT JOIN finance_budgets AS fb ON ft.from_fund_id = fb.fund_id AND ft.fiscal_year_id = fb.fiscal_year_id
    LEFT JOIN organization_organizations AS oo ON json_extract_path_text(ii.data, 'vendorId') = oo.id
WHERE
    transaction_type = 'Pending payment'
    OR transaction_type = 'Payment'
    OR transaction_type = 'Credit';

