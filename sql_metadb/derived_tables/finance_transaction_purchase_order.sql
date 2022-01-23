DROP TABLE IF EXISTS folio_derived.finance_transaction_purchase_order;

-- Create a derived table that joins purchase orders and po_lines fields to transactions for encumbranced cost reports in system currency
--
-- Tables included:
--    finance_transactions
--    finance_funds
--    finance_budget
--    po_lines
--    po_purchase_orders
CREATE TABLE folio_derived.finance_transaction_purchase_order AS
SELECT
    ft.id AS transaction_id,
    jsonb_extract_path_text(ft.jsonb, 'amount') AS transaction_amount,
    jsonb_extract_path_text(ft.jsonb, 'currency') AS transaction_currency,
    ft.expenseclassid AS transaction_expense_class_id,
    ft.fiscalyearid AS transaction_fiscal_year_id,
    ft.fromfundid AS transaction_from_fund_id,
    jsonb_extract_path_text(ff.jsonb, 'name') AS transaction_from_fund_name,
    jsonb_extract_path_text(ff.jsonb, 'code') AS transaction_from_fund_code,
    fb.id AS transaction_from_budget_id,
    jsonb_extract_path_text(fb.jsonb, 'name') AS transaction_from_budget_name,
    jsonb_extract_path_text(ft.jsonb, 'encumbrance', 'amountAwaitingPayment') AS transaction_encumbrance_amount_awaiting_payment,
    jsonb_extract_path_text(ft.jsonb, 'encumbrance', 'amountExpended') AS transaction_encumbrance_amount_expended,
    jsonb_extract_path_text(ft.jsonb, 'encumbrance', 'initialAmountEncumbered') AS transaction_encumbrance_initial_amount,
    jsonb_extract_path_text(ft.jsonb, 'encumbrance', 'orderType') AS transaction_encumbrance_order_type,
    jsonb_extract_path_text(ft.jsonb, 'encumbrance', 'subscription') AS transaction_encumbrance_subscription,
    jsonb_extract_path_text(ft.jsonb, 'encumbrance', 'sourcePoLineId') AS po_line_id,
    jsonb_extract_path_text(ft.jsonb, 'encumbrance', 'sourcePurchaseOrderId') AS po_id,
    jsonb_extract_path_text(pol.jsonb, 'poLineNumber') AS pol_number,
    jsonb_extract_path_text(pol.jsonb, 'description') AS pol_description,
    jsonb_extract_path_text(pol.jsonb, 'acquisition_method') AS pol_acquisition_method,
    jsonb_extract_path_text(po.jsonb, 'order_type') AS po_order_type,
    jsonb_extract_path_text(po.jsonb, 'vendor') AS po_vendor_id,
    jsonb_extract_path_text(oo.jsonb, 'name') AS po_vendor_name
FROM
    folio_finance.transaction AS ft
    LEFT JOIN folio_orders.po_line AS pol ON jsonb_extract_path_text(ft.jsonb, 'encumbrance', 'sourcePoLineId') = pol.id
    LEFT JOIN folio_orders.purchase_order AS po ON jsonb_extract_path_text(ft.jsonb, 'encumbrance', 'sourcePurchaseOrderId') = po.id
    LEFT JOIN folio_finance.fund AS ff ON ft.fromfundid = ff.id
    LEFT JOIN folio_finance.budget AS fb ON ft.fromfundid = fb.fundid AND ft.fiscalyearid = fb.fiscalyearid
    LEFT JOIN folio_organizations. organizations AS oo ON jsonb_extract_path_text(po.jsonb, 'vendor') = oo.id
WHERE
    jsonb_extract_path_text(ft.jsonb, 'transactionType') = 'Encumbrance';

CREATE INDEX ON folio_derived.finance_transaction_purchase_order (transaction_id);

CREATE INDEX ON folio_derived.finance_transaction_purchase_order (transaction_amount);

CREATE INDEX ON folio_derived.finance_transaction_purchase_order (transaction_currency);

CREATE INDEX ON folio_derived.finance_transaction_purchase_order (transaction_expense_class_id);

CREATE INDEX ON folio_derived.finance_transaction_purchase_order (transaction_fiscal_year_id);

CREATE INDEX ON folio_derived.finance_transaction_purchase_order (transaction_from_fund_id);

CREATE INDEX ON folio_derived.finance_transaction_purchase_order (transaction_from_fund_name);

CREATE INDEX ON folio_derived.finance_transaction_purchase_order (transaction_from_fund_code);

CREATE INDEX ON folio_derived.finance_transaction_purchase_order (transaction_from_budget_id);

CREATE INDEX ON folio_derived.finance_transaction_purchase_order (transaction_from_budget_name);

CREATE INDEX ON folio_derived.finance_transaction_purchase_order (transaction_encumbrance_amount_awaiting_payment);

CREATE INDEX ON folio_derived.finance_transaction_purchase_order (transaction_encumbrance_amount_expended);

CREATE INDEX ON folio_derived.finance_transaction_purchase_order (transaction_encumbrance_initial_amount);

CREATE INDEX ON folio_derived.finance_transaction_purchase_order (transaction_encumbrance_order_type);

CREATE INDEX ON folio_derived.finance_transaction_purchase_order (transaction_encumbrance_subscription);

CREATE INDEX ON folio_derived.finance_transaction_purchase_order (po_line_id);

CREATE INDEX ON folio_derived.finance_transaction_purchase_order (po_id);

CREATE INDEX ON folio_derived.finance_transaction_purchase_order (pol_number);

CREATE INDEX ON folio_derived.finance_transaction_purchase_order (pol_description);

CREATE INDEX ON folio_derived.finance_transaction_purchase_order (pol_acquisition_method);

CREATE INDEX ON folio_derived.finance_transaction_purchase_order (po_order_type);

CREATE INDEX ON folio_derived.finance_transaction_purchase_order (po_vendor_id);

CREATE INDEX ON folio_derived.finance_transaction_purchase_order (po_vendor_name);
