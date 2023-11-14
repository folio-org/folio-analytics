--metadb:table po_lines_fund_distribution_transactions

DROP TABLE IF EXISTS po_lines_fund_distribution_transactions;

-- Create a derived table that contains information about the fund distribution in the po lines
--
CREATE TABLE po_lines_fund_distribution_transactions AS
WITH po_line AS (
    SELECT
        id AS po_line_id,
        purchaseorderid,
        jsonb_extract_path_text(dist.data, 'code') AS fund_distribution_code,
        cast(jsonb_extract_path_text(dist.data, 'fundId') AS uuid) AS fund_distribution_id,
        jsonb_extract_path_text(dist.data, 'distributionType') AS fund_distribution_type,
        jsonb_extract_path_text(dist.data, 'value')::numeric(19,4) AS fund_distribution_value,
        jsonb_extract_path_text(po_line.jsonb, 'poLineNumber') AS poline_number,
        cast(jsonb_extract_path_text(po_line.jsonb, 'cost', 'poLineEstimatedPrice') AS numeric(19,4)) AS poline_estimated_price,
        jsonb_extract_path_text(po_line.jsonb, 'cost', 'currency') AS poline_currency,
        cast(jsonb_extract_path_text(po_line.jsonb, 'cost', 'listUnitPrice') AS numeric(19,4)) AS poline_listunitprice,
        cast(jsonb_extract_path_text(po_line.jsonb, 'cost', 'quantityPhysical') AS integer) AS poline_quantityphysical,
        cast(jsonb_extract_path_text(po_line.jsonb, 'cost', 'listUnitPriceElectronic') AS numeric(19,4)) AS poline_listunitpriceelectronic,
        cast(jsonb_extract_path_text(po_line.jsonb, 'cost', 'quantityElectronic') AS integer) AS poline_quantityelectronic,
        cast(jsonb_extract_path_text(po_line.jsonb, 'cost', 'additionalCost') AS numeric(19,4)) AS poline_additionalcost,
        jsonb_extract_path_text(po_line.jsonb, 'cost', 'discount') AS poline_discount,
        jsonb_extract_path_text(po_line.jsonb, 'cost', 'discountType') AS poline_discounttype,
        cast(jsonb_extract_path_text(po_line.jsonb, 'cost', 'fyroAdjustmentAmount') AS numeric(19,4)) AS po_line_fyroadjustmentamount,
        jsonb_extract_path_text(po_line.jsonb, 'titleOrPackage') AS poline_title_or_package
    FROM
        folio_orders.po_line AS po_line
        CROSS JOIN jsonb_array_elements(jsonb_extract_path(jsonb, 'fundDistribution')) AS dist (data)
),
finance AS (
    SELECT
        finance_storage_fund.id AS fund_id,
        jsonb_extract_path_text(finance_storage_fund.jsonb, 'code') AS fund_code,
        finance_storage_budget.id AS budget_id,
        jsonb_extract_path_text(finance_storage_budget.jsonb, 'name') AS budget_name,
        finance_storage_fiscal_year.id AS fiscal_year_id,
        jsonb_extract_path_text(finance_storage_fiscal_year.jsonb, 'code') AS fiscal_year
    FROM
        folio_finance.fiscal_year AS finance_storage_fiscal_year
        LEFT JOIN folio_finance.ledger AS finance_storage_ledger ON finance_storage_ledger.fiscalyearoneid = finance_storage_fiscal_year.id
        LEFT JOIN folio_finance.fund AS finance_storage_fund ON finance_storage_fund.ledgerid = finance_storage_ledger.id
        LEFT JOIN folio_finance.budget AS finance_storage_budget ON finance_storage_budget.fundid = finance_storage_fund.id
            AND finance_storage_budget.fiscalyearid = finance_storage_fiscal_year.id
),
transactions AS (
    SELECT
        finance_transaction.id AS transaction_id,
        jsonb_extract_path_text(finance_transaction.jsonb, 'currency') AS transaction_currency,
        cast(jsonb_extract_path_text(finance_transaction.jsonb, 'amount') AS numeric(19,4)) AS transaction_amount,
        cast(jsonb_extract_path_text(finance_transaction.jsonb, 'encumbrance', 'initialAmountEncumbered') AS numeric(19,4)) AS transaction_encumbrance_initial_amount,
        cast(jsonb_extract_path_text(finance_transaction.jsonb, 'encumbrance', 'amountExpended') AS numeric(19,4)) AS transaction_encumbrance_amount_expended,
        jsonb_extract_path_text(finance_transaction.jsonb, 'encumbrance', 'orderType') AS transaction_encumbrance_order_type,
        cast(jsonb_extract_path_text(finance_transaction.jsonb, 'encumbrance', 'subscription') AS boolean) AS transaction_encumbrance_subscription,
        cast(jsonb_extract_path_text(finance_transaction.jsonb, 'encumbrance', 'sourcePoLineId') AS uuid) AS sourcepolineid,
        cast(jsonb_extract_path_text(finance_transaction.jsonb, 'encumbrance', 'sourcePurchaseOrderId') AS uuid) AS sourcepurchaseorderid,
        cast(jsonb_extract_path_text(finance_transaction.jsonb, 'fromFundId') AS uuid) AS fromfundid
    FROM
        folio_finance.transaction AS finance_transaction
    WHERE
        jsonb_extract_path_text(finance_transaction.jsonb, 'transactionType') = 'Encumbrance'
        AND jsonb_extract_path_text(finance_transaction.jsonb, 'source') = 'PoLine'
)
SELECT
    purchase_order.id AS po_id,
    jsonb_extract_path_text(purchase_order.jsonb, 'poNumber') AS po_number,
    jsonb_extract_path_text(purchase_order.jsonb, 'workflowStatus') AS po_workflowstatus,
    po_line.po_line_id,
    po_line.poline_number,
    po_line.poline_title_or_package,
    po_line.poline_listunitprice,
    po_line.poline_quantityphysical,
    po_line.poline_listunitpriceelectronic,
    po_line.poline_quantityelectronic,
    po_line.poline_currency,
    po_line.poline_discount,
    po_line.poline_discounttype,
    po_line.poline_additionalcost,
    po_line.poline_estimated_price,
    po_line.po_line_fyroadjustmentamount,
    po_line.fund_distribution_value,
    po_line.fund_distribution_type,
    finance.budget_id,
    finance.budget_name,
    finance.fund_id,
    finance.fund_code,
    finance.fiscal_year_id,
    finance.fiscal_year,
    transactions.transaction_id,
    transactions.transaction_currency,
    transactions.transaction_amount,
    transactions.transaction_encumbrance_initial_amount,
    transactions.transaction_encumbrance_amount_expended,
    transactions.transaction_encumbrance_order_type,
    transactions.transaction_encumbrance_subscription
FROM
    folio_orders.purchase_order AS purchase_order
    LEFT JOIN po_line ON po_line.purchaseorderid = purchase_order.id
    LEFT JOIN finance ON finance.fund_id = po_line.fund_distribution_id
    LEFT JOIN transactions ON transactions.sourcepolineid = po_line.po_line_id
        AND transactions.fromfundid = po_line.fund_distribution_id
    ORDER BY
        po_number,
        poline_number;

COMMENT ON COLUMN po_lines_fund_distribution_transactions.po_id IS 'UUID identifying this entity';

COMMENT ON COLUMN po_lines_fund_distribution_transactions.po_number IS 'A human readable ID assigned to this purchase order';

COMMENT ON COLUMN po_lines_fund_distribution_transactions.po_workflowstatus IS 'the workflow status for this purchase order';

COMMENT ON COLUMN po_lines_fund_distribution_transactions.po_line_id IS 'UUID identifying this purchase order line';

COMMENT ON COLUMN po_lines_fund_distribution_transactions.poline_number IS 'A human readable number assigned to this PO line';

COMMENT ON COLUMN po_lines_fund_distribution_transactions.poline_title_or_package IS 'title of the material';

COMMENT ON COLUMN po_lines_fund_distribution_transactions.poline_listunitprice IS 'The per-item list price for physical or resources of Other order format';

COMMENT ON COLUMN po_lines_fund_distribution_transactions.poline_quantityphysical IS 'Quantity of physical items or resources of Other order format in this purchase order line';

COMMENT ON COLUMN po_lines_fund_distribution_transactions.poline_listunitpriceelectronic IS 'The e-resource per-item list price';

COMMENT ON COLUMN po_lines_fund_distribution_transactions.poline_quantityelectronic IS 'Quantity of electronic items in this purchase order line';

COMMENT ON COLUMN po_lines_fund_distribution_transactions.poline_currency IS 'An ISO currency code';

COMMENT ON COLUMN po_lines_fund_distribution_transactions.poline_discount IS 'Percentage (0 to 100) or amount (positive number) that is subtracted from the list price time quantities calculation before additional cost';

COMMENT ON COLUMN po_lines_fund_distribution_transactions.poline_discounttype IS 'Percentage or amount discount type';

COMMENT ON COLUMN po_lines_fund_distribution_transactions.poline_additionalcost IS 'Lump sum that is added to the total estimated price - not affected by discount';

COMMENT ON COLUMN po_lines_fund_distribution_transactions.poline_estimated_price IS 'The calculated total estimated price for this purchase order line: list price time quantities minus discount amount plus additional cost';

COMMENT ON COLUMN po_lines_fund_distribution_transactions.po_line_fyroadjustmentamount IS 'Adjustment amount if rollover was happen';

COMMENT ON COLUMN po_lines_fund_distribution_transactions.fund_distribution_value IS 'The value of the cost to be applied to this fund';

COMMENT ON COLUMN po_lines_fund_distribution_transactions.fund_distribution_type IS 'Percentage or amount type of the value property';

COMMENT ON COLUMN po_lines_fund_distribution_transactions.budget_id IS 'UUID of the budget record';

COMMENT ON COLUMN po_lines_fund_distribution_transactions.budget_name IS 'The name of the budget';

COMMENT ON COLUMN po_lines_fund_distribution_transactions.fund_id IS 'UUID of the fund associated with this fund distribution';

COMMENT ON COLUMN po_lines_fund_distribution_transactions.fund_code IS 'the fund code';

COMMENT ON COLUMN po_lines_fund_distribution_transactions.fiscal_year_id IS 'UUID of the fiscal year record';

COMMENT ON COLUMN po_lines_fund_distribution_transactions.fiscal_year IS 'The fiscal year';

COMMENT ON COLUMN po_lines_fund_distribution_transactions.transaction_id IS 'UUID of this transaction';

COMMENT ON COLUMN po_lines_fund_distribution_transactions.transaction_currency IS 'Currency code for this transaction - from the system currency';

COMMENT ON COLUMN po_lines_fund_distribution_transactions.transaction_amount IS 'The amount of this transaction. For encumbrances: This is initialAmountEncumbered - (amountAwaitingPayment + amountExpended)';

COMMENT ON COLUMN po_lines_fund_distribution_transactions.transaction_encumbrance_initial_amount IS 'The initial amount of this encumbrance. Should not change once create';

COMMENT ON COLUMN po_lines_fund_distribution_transactions.transaction_encumbrance_amount_expended IS 'The amount currently expended by this encumbrance';

COMMENT ON COLUMN po_lines_fund_distribution_transactions.transaction_encumbrance_order_type IS 'Taken from the purchase order';

COMMENT ON COLUMN po_lines_fund_distribution_transactions.transaction_encumbrance_subscription IS 'Taken from the purchase Order,for fiscal year rollover';

