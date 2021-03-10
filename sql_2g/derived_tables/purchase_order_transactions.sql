DROP TABLE IF EXISTS folio_reporting.purchase_order_transactions;

-- Create a derived table that joins purchase orders and po_lines fields to transactions for encumbranced cost reports in system currency
--
-- Tables included:
--    finance_transactions
--    finance_funds
--    finance_budget
--    po_lines
--    po_purchase_orders
CREATE TABLE folio_reporting.purchase_order_transactions AS
SELECT
    ft.id AS transaction_id,
    json_extract_path_text(ft.jsonb::json, 'amount') AS transaction_amount,
    json_extract_path_text(ft.jsonb::json, 'currency') AS transaction_currency,
    ft.expenseclassid AS transaction_expense_class_id,
    ft.fiscalyearid AS transaction_fiscal_year_id,
    ft.fromfundid AS transaction_from_fund_id,
    json_extract_path_text(ff.jsonb::json, 'name') AS transaction_from_fund_name,
    json_extract_path_text(ff.jsonb::json, 'code') AS transaction_from_fund_code,
    fb.id AS transaction_from_budget_id,
    json_extract_path_text(fb.jsonb::json, 'name') AS transaction_from_budget_name,
    json_extract_path_text(ft.jsonb::json, 'encumbrance', 'amountAwaitingPayment') AS transaction_encumbrance_amount_awaiting_payment,
    json_extract_path_text(ft.jsonb::json, 'encumbrance', 'amountExpended') AS transaction_encumbrance_amount_expended,
    json_extract_path_text(ft.jsonb::json, 'encumbrance', 'initialAmountEncumbered') AS transaction_encumbrance_initial_amount,
    json_extract_path_text(ft.jsonb::json, 'encumbrance', 'orderType') AS transaction_encumbrance_order_type,
    json_extract_path_text(ft.jsonb::json, 'encumbrance', 'subscription') AS transaction_encumbrance_subscription,
    json_extract_path_text(ft.jsonb::json, 'encumbrance', 'sourcePoLineId') AS po_line_id,
    json_extract_path_text(ft.jsonb::json, 'encumbrance', 'sourcePurchaseOrderId') AS po_id,
    json_extract_path_text(pol.jsonb::json, 'poLineNumber') AS pol_number,
    json_extract_path_text(pol.jsonb::json, 'description') AS pol_description,
    json_extract_path_text(pol.jsonb::json, 'acquisition_method') AS pol_acquisition_method,
    json_extract_path_text(po.jsonb::json, 'order_type') AS po_order_type,
    json_extract_path_text(po.jsonb::json, 'vendor') AS po_vendor_id
FROM
    folio_finance.transaction AS ft
    LEFT JOIN folio_orders.po_line AS pol ON json_extract_path_text(ft.jsonb::json, 'encumbrance', 'sourcePoLineId') = pol.id
    LEFT JOIN folio_orders.purchase_order AS po ON json_extract_path_text(ft.jsonb::json, 'encumbrance', 'sourcePurchaseOrderId') = po.id
    LEFT JOIN folio_finance.fund AS ff ON ft.fromfundid = ff.id
    LEFT JOIN folio_finance.budget AS fb ON ft.fromfundid = fb.fundid
WHERE
    json_extract_path_text(ft.jsonb::json, 'transactionType') = 'Encumbrance'
    AND ft.__current
    AND po.__current
    AND pol.__current
    AND ff.__current
    AND fb.__current;

CREATE INDEX ON folio_reporting.purchase_order_transactions (transaction_id);

CREATE INDEX ON folio_reporting.purchase_order_transactions (transaction_amount);

CREATE INDEX ON folio_reporting.purchase_order_transactions (transaction_currency);

CREATE INDEX ON folio_reporting.purchase_order_transactions (transaction_expense_class_id);

CREATE INDEX ON folio_reporting.purchase_order_transactions (transaction_fiscal_year_id);

CREATE INDEX ON folio_reporting.purchase_order_transactions (transaction_from_fund_id);

CREATE INDEX ON folio_reporting.purchase_order_transactions (transaction_from_fund_name);

CREATE INDEX ON folio_reporting.purchase_order_transactions (transaction_from_fund_code);

CREATE INDEX ON folio_reporting.purchase_order_transactions (transaction_from_budget_id);

CREATE INDEX ON folio_reporting.purchase_order_transactions (transaction_from_budget_name);

CREATE INDEX ON folio_reporting.purchase_order_transactions (transaction_encumbrance_amount_awaiting_payment);

CREATE INDEX ON folio_reporting.purchase_order_transactions (transaction_encumbrance_amount_expended);

CREATE INDEX ON folio_reporting.purchase_order_transactions (transaction_encumbrance_initial_amount);

CREATE INDEX ON folio_reporting.purchase_order_transactions (transaction_encumbrance_order_type);

CREATE INDEX ON folio_reporting.purchase_order_transactions (transaction_encumbrance_subscription);

CREATE INDEX ON folio_reporting.purchase_order_transactions (po_line_id);

CREATE INDEX ON folio_reporting.purchase_order_transactions (po_id);

CREATE INDEX ON folio_reporting.purchase_order_transactions (pol_number);

CREATE INDEX ON folio_reporting.purchase_order_transactions (pol_description);

CREATE INDEX ON folio_reporting.purchase_order_transactions (pol_acquisition_method);

CREATE INDEX ON folio_reporting.purchase_order_transactions (po_order_type);

CREATE INDEX ON folio_reporting.purchase_order_transactions (po_vendor_id);

