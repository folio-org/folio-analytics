--metadb:table finance_transaction_purchase_order

-- Create a derived table that joins purchase orders and po_lines fields to transactions for encumbranced cost reports in system currency

DROP TABLE IF EXISTS finance_transaction_purchase_order;

CREATE TABLE finance_transaction_purchase_order AS
SELECT
    ft.id AS transaction_id,
    jsonb_extract_path_text(ft.jsonb, 'amount')::numeric(19,4) AS transaction_amount,
    jsonb_extract_path_text(ft.jsonb, 'currency') AS transaction_currency,
    ft.expenseclassid AS transaction_expense_class_id,
    ec.code AS transaction_expense_class_code,
    ec.name AS transaction_expense_class_name,
    ec.external_account_number_ext,    
    ft.fiscalyearid AS transaction_fiscal_year_id,
    ft.fromfundid AS transaction_from_fund_id,
    jsonb_extract_path_text(ff.jsonb, 'name') AS transaction_from_fund_name,
    jsonb_extract_path_text(ff.jsonb, 'code') AS transaction_from_fund_code,
    fb.id AS transaction_from_budget_id,
    jsonb_extract_path_text(fb.jsonb, 'name') AS transaction_from_budget_name,
    jsonb_extract_path_text(ft.jsonb, 'encumbrance', 'amountAwaitingPayment')::numeric(19,4) AS transaction_encumbrance_amount_awaiting_payment,
    jsonb_extract_path_text(ft.jsonb, 'encumbrance', 'amountExpended')::numeric(19,4) AS transaction_encumbrance_amount_expended,
    jsonb_extract_path_text(ft.jsonb, 'encumbrance', 'initialAmountEncumbered')::numeric(19,4) AS transaction_encumbrance_initial_amount,
    jsonb_extract_path_text(ft.jsonb, 'encumbrance', 'orderType') AS transaction_encumbrance_order_type,
    jsonb_extract_path_text(ft.jsonb, 'encumbrance', 'subscription') AS transaction_encumbrance_subscription,
    jsonb_extract_path_text(ft.jsonb, 'encumbrance', 'status') AS transaction_encumbrance_status,
    jsonb_extract_path_text(ft.jsonb, 'encumbrance', 'sourcePoLineId')::uuid AS po_line_id,
    jsonb_extract_path_text(ft.jsonb, 'encumbrance', 'sourcePurchaseOrderId')::uuid AS po_id,
    jsonb_extract_path_text(pol.jsonb, 'poLineNumber') AS pol_number,
    jsonb_extract_path_text(pol.jsonb, 'description') AS pol_description,
    jsonb_extract_path_text(pol.jsonb, 'acquisition_method') AS pol_acquisition_method,
    jsonb_extract_path_text(po.jsonb, 'order_type') AS po_order_type,
    jsonb_extract_path_text(po.jsonb, 'vendor')::uuid AS po_vendor_id,
    jsonb_extract_path_text(oo.jsonb, 'name') AS po_vendor_name

FROM
    folio_finance.transaction AS ft
    LEFT JOIN folio_orders.po_line AS pol ON jsonb_extract_path_text(ft.jsonb, 'encumbrance', 'sourcePoLineId')::uuid = pol.id
    LEFT JOIN folio_orders.purchase_order AS po ON jsonb_extract_path_text(ft.jsonb, 'encumbrance', 'sourcePurchaseOrderId')::uuid = po.id
    LEFT JOIN folio_finance.fund AS ff ON ft.fromfundid = ff.id
    LEFT JOIN folio_finance.budget AS fb ON ft.fromfundid = fb.fundid AND ft.fiscalyearid = fb.fiscalyearid
    LEFT JOIN folio_organizations.organizations AS oo ON jsonb_extract_path_text(po.jsonb, 'vendor')::uuid = oo.id
    LEFT JOIN folio_finance.expense_class__t AS ec ON ec.id = ft.expenseclassid

WHERE
    jsonb_extract_path_text(ft.jsonb, 'transactionType') = 'Encumbrance';

COMMENT ON COLUMN finance_transaction_purchase_order.transaction_id IS 'UUID of this transaction';

COMMENT ON COLUMN finance_transaction_purchase_order.transaction_amount IS 'The amount of this transaction. For encumbrances: This is initialAmountEncumbered - (amountAwaitingPayment + amountExpended)';

COMMENT ON COLUMN finance_transaction_purchase_order.transaction_currency IS 'Currency code for this transaction - from the system currency';

COMMENT ON COLUMN finance_transaction_purchase_order.transaction_expense_class_id IS 'UUID of the associated expense class';

COMMENT ON COLUMN finance_transaction_purchase_order.transaction_expense_class_code IS 'Code for the associated expense class';

COMMENT ON COLUMN finance_transaction_purchase_order.transaction_expense_class_name IS 'Name for the associated expense class';

COMMENT ON COLUMN finance_transaction_purchase_order.external_account_number_ext IS 'An external account number extension';

COMMENT ON COLUMN finance_transaction_purchase_order.transaction_fiscal_year_id IS 'UUID of the fiscal year that the transaction is taking place in';

COMMENT ON COLUMN finance_transaction_purchase_order.transaction_from_fund_id IS 'UUID of the fund money is moving from';

COMMENT ON COLUMN finance_transaction_purchase_order.transaction_from_fund_name IS 'The name of this fund';

COMMENT ON COLUMN finance_transaction_purchase_order.transaction_from_fund_code IS 'A unique code associated with the fund';

COMMENT ON COLUMN finance_transaction_purchase_order.transaction_from_budget_id IS 'UUID of this budget';

COMMENT ON COLUMN finance_transaction_purchase_order.transaction_from_budget_name IS 'The name of the budget';

COMMENT ON COLUMN finance_transaction_purchase_order.transaction_encumbrance_amount_awaiting_payment IS 'Deprecated! Going to be removed in next release. The amount of awaiting for payment';

COMMENT ON COLUMN finance_transaction_purchase_order.transaction_encumbrance_amount_expended IS 'The amount currently expended by this encumbrance';

COMMENT ON COLUMN finance_transaction_purchase_order.transaction_encumbrance_initial_amount IS 'The initial amount of this encumbrance. Should not change once create';

COMMENT ON COLUMN finance_transaction_purchase_order.transaction_encumbrance_order_type IS 'Taken from the purchase order';

COMMENT ON COLUMN finance_transaction_purchase_order.transaction_encumbrance_subscription IS 'Taken from the purchase Order,for fiscal year rollover';

COMMENT ON COLUMN finance_transaction_purchase_order.transaction_encumbrance_status IS 'The status of this encumbrance';

COMMENT ON COLUMN finance_transaction_purchase_order.po_line_id IS 'UUID referencing the poLine that represents the package that this POLs title belongs to';

COMMENT ON COLUMN finance_transaction_purchase_order.po_id IS 'UUID identifying this purchase order line';

COMMENT ON COLUMN finance_transaction_purchase_order.pol_number IS 'A human readable number assigned to this PO line';

COMMENT ON COLUMN finance_transaction_purchase_order.pol_description IS 'purchase order line description';

COMMENT ON COLUMN finance_transaction_purchase_order.pol_acquisition_method IS 'UUID of the acquisition method for this purchase order line';

COMMENT ON COLUMN finance_transaction_purchase_order.po_order_type IS 'the purchase order type';

COMMENT ON COLUMN finance_transaction_purchase_order.po_vendor_id IS 'UUID of the vendor record';

COMMENT ON COLUMN finance_transaction_purchase_order.po_vendor_name IS 'The name of vendor';

