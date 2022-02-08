DROP TABLE IF EXISTS po_line_fund_distribution_transactions;

-- Create a derived table that contains information about the fund distribution in the po lines
--
CREATE TABLE po_line_fund_distribution_transactions AS
WITH po_line AS (
    SELECT
        id AS po_line_id,
        purchaseorderid,
        jsonb_extract_path_text(dist.data, 'code') AS fund_distribution_code,
        cast(jsonb_extract_path_text(dist.data, 'fundId') AS uuid) AS fund_distribution_id,
        jsonb_extract_path_text(dist.data, 'distributionType') AS fund_distribution_type,
        jsonb_extract_path_text(dist.data, 'value')::numeric AS fund_distribution_value,
        jsonb_extract_path_text(po_line.jsonb, 'poLineNumber') AS poline_number,
        cast(jsonb_extract_path_text(po_line.jsonb, 'cost', 'poLineEstimatedPrice') AS money) AS poline_estimated_price,
        jsonb_extract_path_text(po_line.jsonb, 'cost', 'currency') AS poline_currency,
        cast(jsonb_extract_path_text(po_line.jsonb, 'cost', 'listUnitPrice') AS money) AS poline_listUnitPrice,
        cast(jsonb_extract_path_text(po_line.jsonb, 'cost', 'quantityPhysical') AS integer) AS poline_quantityPhysical,
        cast(jsonb_extract_path_text(po_line.jsonb, 'cost', 'listUnitPriceElectronic') AS money) AS poline_listUnitPriceElectronic,
        cast(jsonb_extract_path_text(po_line.jsonb, 'cost', 'quantityElectronic') AS integer) AS poline_quantityElectronic,
        cast(jsonb_extract_path_text(po_line.jsonb, 'cost', 'additionalCost') AS money) AS poline_additionalCost,
        jsonb_extract_path_text(po_line.jsonb, 'cost', 'discount') AS poline_discount,
        jsonb_extract_path_text(po_line.jsonb, 'cost', 'discountType') AS poline_discountType,
        cast(jsonb_extract_path_text(po_line.jsonb, 'cost', 'fyroAdjustmentAmount') AS money) AS po_line_fyroAdjustmentAmount,
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
        cast(jsonb_extract_path_text(finance_transaction.jsonb, 'amount') AS money) AS transaction_amount,
        cast(jsonb_extract_path_text(finance_transaction.jsonb, 'encumbrance', 'initialAmountEncumbered') AS money) AS transaction_encumbrance_initial_amount,
        cast(jsonb_extract_path_text(finance_transaction.jsonb, 'encumbrance', 'amountExpended') AS money) AS transaction_encumbrance_amount_expended,
        jsonb_extract_path_text(finance_transaction.jsonb, 'encumbrance', 'orderType') AS transaction_encumbrance_order_type,
        cast(jsonb_extract_path_text(finance_transaction.jsonb, 'encumbrance', 'subscription') AS boolean) AS transaction_encumbrance_subscription,
        cast(jsonb_extract_path_text(finance_transaction.jsonb, 'encumbrance', 'sourcePoLineId') AS uuid) AS sourcePoLineId,
        cast(jsonb_extract_path_text(finance_transaction.jsonb, 'encumbrance', 'sourcePurchaseOrderId') AS uuid) AS sourcePurchaseOrderId,
        cast(jsonb_extract_path_text(finance_transaction.jsonb, 'fromFundId') AS uuid) AS fromFundId
    FROM
        folio_finance.transaction AS finance_transaction
    WHERE
        jsonb_extract_path_text(finance_transaction.jsonb, 'transactionType') = 'Encumbrance'
        AND jsonb_extract_path_text(finance_transaction.jsonb, 'source') = 'PoLine'
)
SELECT
    purchase_order.id AS po_id,
    jsonb_extract_path_text(purchase_order.jsonb, 'poNumber') AS po_number,
    jsonb_extract_path_text(purchase_order.jsonb, 'workflowStatus') AS po_workflowStatus,
    po_line.po_line_id,
    po_line.poline_number,
    po_line.poline_title_or_package,
    po_line.poline_listUnitPrice,
    po_line.poline_quantityPhysical,
    po_line.poline_listUnitPriceElectronic,
    po_line.poline_quantityElectronic,
    po_line.poline_currency,
    po_line.poline_discount,
    po_line.poline_discountType,
    po_line.poline_additionalCost,
    po_line.poline_estimated_price,
    po_line.po_line_fyroAdjustmentAmount,
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
    LEFT JOIN transactions ON transactions.sourcePoLineId = po_line.po_line_id
        AND transactions.fromFundId = po_line.fund_distribution_id
    ORDER BY
        po_number,
        poline_number;

CREATE INDEX ON po_line_fund_distribution_transactions (po_id);

CREATE INDEX ON po_line_fund_distribution_transactions (po_number);

CREATE INDEX ON po_line_fund_distribution_transactions (po_workflowStatus);

CREATE INDEX ON po_line_fund_distribution_transactions (po_line_id);

CREATE INDEX ON po_line_fund_distribution_transactions (poline_number);

CREATE INDEX ON po_line_fund_distribution_transactions (poline_title_or_package);

CREATE INDEX ON po_line_fund_distribution_transactions (poline_listUnitPrice);

CREATE INDEX ON po_line_fund_distribution_transactions (poline_quantityPhysical);

CREATE INDEX ON po_line_fund_distribution_transactions (poline_listUnitPriceElectronic);

CREATE INDEX ON po_line_fund_distribution_transactions (poline_quantityElectronic);

CREATE INDEX ON po_line_fund_distribution_transactions (poline_currency);

CREATE INDEX ON po_line_fund_distribution_transactions (poline_discount);

CREATE INDEX ON po_line_fund_distribution_transactions (poline_discountType);

CREATE INDEX ON po_line_fund_distribution_transactions (poline_additionalCost);

CREATE INDEX ON po_line_fund_distribution_transactions (poline_estimated_price);

CREATE INDEX ON po_line_fund_distribution_transactions (po_line_fyroAdjustmentAmount);

CREATE INDEX ON po_line_fund_distribution_transactions (fund_distribution_value);

CREATE INDEX ON po_line_fund_distribution_transactions (fund_distribution_type);

CREATE INDEX ON po_line_fund_distribution_transactions (budget_id);

CREATE INDEX ON po_line_fund_distribution_transactions (budget_name);

CREATE INDEX ON po_line_fund_distribution_transactions (fund_id);

CREATE INDEX ON po_line_fund_distribution_transactions (fund_code);

CREATE INDEX ON po_line_fund_distribution_transactions (fiscal_year_id);

CREATE INDEX ON po_line_fund_distribution_transactions (fiscal_year);

CREATE INDEX ON po_line_fund_distribution_transactions (transaction_id);

CREATE INDEX ON po_line_fund_distribution_transactions (transaction_currency);

CREATE INDEX ON po_line_fund_distribution_transactions (transaction_amount);

CREATE INDEX ON po_line_fund_distribution_transactions (transaction_encumbrance_initial_amount);

CREATE INDEX ON po_line_fund_distribution_transactions (transaction_encumbrance_amount_expended);

CREATE INDEX ON po_line_fund_distribution_transactions (transaction_encumbrance_order_type);

CREATE INDEX ON po_line_fund_distribution_transactions (transaction_encumbrance_subscription);

VACUUM ANALYZE po_line_fund_distribution_transactions;
