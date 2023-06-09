-- Create a derived table that joins purchase orders and po_lines fields to transactions for encumbranced cost reports in system currency

DROP TABLE IF EXISTS finance_transaction_purchase_order;

CREATE TABLE finance_transaction_purchase_order AS
SELECT
    ft.id AS transaction_id,
    ft.amount AS transaction_amount,
    ft.currency AS transaction_currency,
    ft.data->>'expenseClassId' AS transaction_expense_class_id,
    ft.fiscal_year_id AS transaction_fiscal_year_id,
    ft.from_fund_id AS transaction_from_fund_id,
    ff.name AS transaction_from_fund_name,
    ff.code AS transaction_from_fund_code,
    fb.id AS transaction_from_budget_id,
    fb.name AS transaction_from_budget_name,
    ft.data->'encumbrance'->>'amountAwaitingPayment' AS transaction_encumbrance_amount_awaiting_payment,
    ft.data->'encumbrance'->>'amountExpended' AS transaction_encumbrance_amount_expended,
    ft.data->'encumbrance'->>'initialAmountEncumbered' AS transaction_encumbrance_initial_amount,
    ft.data->'encumbrance'->>'orderType' AS transaction_encumbrance_order_type,
    ft.data->'encumbrance'->>'subscription' AS transaction_encumbrance_subscription,
    ft.data->'encumbrance'->>'status' AS transaction_encumbrance_status,
    ft.data->'encumbrance'->>'sourcePoLineId' AS po_line_id,
    ft.data->'encumbrance'->>'sourcePurchaseOrderId' AS po_id,
    pol.po_line_number AS pol_number,
    pol.data->>'description' AS pol_description,
    pol.acquisition_method AS pol_acquisition_method,
    po.order_type AS po_order_type,
    po.vendor AS po_vendor_id,
    oo.name AS po_vendor_name
FROM
    finance_transactions AS ft
    LEFT JOIN po_lines AS pol ON ft.data->'encumbrance'->>'sourcePoLineId' = pol.id
    LEFT JOIN po_purchase_orders AS po ON ft.data->'encumbrance'->>'sourcePurchaseOrderId' = po.id
    LEFT JOIN finance_funds AS ff ON ft.from_fund_id = ff.id
    LEFT JOIN finance_budgets AS fb ON ft.from_fund_id = fb.fund_id AND ft.fiscal_year_id = fb.fiscal_year_id
    LEFT JOIN organization_organizations AS oo ON po.vendor = oo.id
WHERE
    ft.transaction_type = 'Encumbrance';

COMMENT ON COLUMN finance_transaction_purchase_order.transaction_id IS 'UUID of this transaction';

COMMENT ON COLUMN finance_transaction_purchase_order.transaction_amount IS 'The amount of this transaction. For encumbrances: This is initialAmountEncumbered - (amountAwaitingPayment + amountExpended)';

COMMENT ON COLUMN finance_transaction_purchase_order.transaction_currency IS 'Currency code for this transaction - from the system currency';

COMMENT ON COLUMN finance_transaction_purchase_order.transaction_expense_class_id IS 'UUID of the associated expense class';

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
