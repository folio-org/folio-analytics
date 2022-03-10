DROP TABLE IF EXISTS finance_po_inv_transactions;

-- Create a derived table that contains information about the fund distribution in po lines and invoice lines
-- including information on the transaction and budget.
CREATE TABLE finance_po_inv_transactions AS
WITH orders_invoice AS (
    SELECT
        -- purchase_order
        purchase_order.id AS po_id,
        jsonb_extract_path_text(purchase_order.jsonb, 'poNumber') AS po_number,
        jsonb_extract_path_text(purchase_order.jsonb, 'workflowStatus') AS po_workflowStatus,
        -- po_line
        po_line.id AS po_line_id,
        jsonb_extract_path_text(po_line.jsonb, 'poLineNumber') AS po_line_number,
        jsonb_extract_path_text(po_line.jsonb, 'titleOrPackage') AS po_line_title_or_package,
        jsonb_extract_path_text(po_line.jsonb, 'cost', 'poLineEstimatedPrice')::numeric(19, 4) AS po_line_estimated_price,
        jsonb_extract_path_text(po_line.jsonb, 'cost', 'currency') AS po_line_currency,
        jsonb_extract_path_text(po_line.jsonb, 'cost', 'fyroAdjustmentAmount')::numeric(19, 4) AS po_line_fyroAdjustmentAmount,
        jsonb_extract_path_text(po_line.jsonb, 'cost', 'listUnitPrice')::numeric(19, 4) AS po_line_listUnitPrice,
        jsonb_extract_path_text(po_line.jsonb, 'cost', 'quantityPhysical')::integer AS po_line_quantityPhysical,
        jsonb_extract_path_text(po_line.jsonb, 'cost', 'listUnitPriceElectronic')::numeric(19, 4) AS po_line_listUnitPriceElectronic,
        jsonb_extract_path_text(po_line.jsonb, 'cost', 'quantityElectronic')::integer AS po_line_quantityElectronic,
        jsonb_extract_path_text(po_line.jsonb, 'cost', 'additionalCost')::numeric(19, 4) AS po_line_additionalCost,
        jsonb_extract_path_text(po_line.jsonb, 'cost', 'discount') AS po_line_discount,
        jsonb_extract_path_text(po_line.jsonb, 'cost', 'discountType') AS po_line_discountType,
        jsonb_extract_path_text(jsonb_array_elements(po_line.jsonb -> 'fundDistribution'), 'fundId')::uuid AS po_line_fund_id,
        jsonb_extract_path_text(jsonb_array_elements(po_line.jsonb -> 'fundDistribution'), 'value')::numeric(19, 4) AS po_line_distribution_value,
        jsonb_extract_path_text(jsonb_array_elements(po_line.jsonb -> 'fundDistribution'), 'distributionType') AS po_line_distribution_type,
        -- invoices
        invoices.id AS invoice_id,
        jsonb_extract_path_text(invoices.jsonb, 'folioInvoiceNo') AS folio_invoice_number,
        jsonb_extract_path_text(invoices.jsonb, 'vendorInvoiceNo') AS vendor_invoice_number,
        jsonb_extract_path_text(invoices.jsonb, 'invoiceDate')::timestamptz AS invoice_date,
        jsonb_extract_path_text(invoices.jsonb, 'currency') AS invoice_currency,
        jsonb_extract_path_text(invoices.jsonb, 'exchangeRate')::numeric(19, 14) AS invoice_exchange_rate,
        jsonb_extract_path_text(invoices.jsonb, 'status') AS invoice_status,
        -- invoice_lines
        invoice_lines.id AS invoice_line_id,
        jsonb_extract_path_text(invoice_lines.jsonb, 'poLineId')::uuid AS invoice_line_poline_id,
        jsonb_extract_path_text(invoice_lines.jsonb, 'total')::numeric(19, 4) AS invoice_line_total,
        jsonb_extract_path_text(jsonb_array_elements(invoice_lines.jsonb -> 'fundDistributions'), 'fundId')::uuid AS invoice_line_fund_id,
        jsonb_extract_path_text(jsonb_array_elements(invoice_lines.jsonb -> 'fundDistributions'), 'value')::numeric(19, 4) AS invoice_line_distribution_value,
        jsonb_extract_path_text(jsonb_array_elements(invoice_lines.jsonb -> 'fundDistributions'), 'distributionType') AS invoice_line_distribution_type,
        -- organizations
        invoice_organizations.id AS invoice_vendor_id,
        jsonb_extract_path_text(invoice_organizations.jsonb, 'name') AS invoice_vendor_name
    FROM
        folio_orders.po_line AS po_line
        LEFT JOIN folio_orders.purchase_order AS purchase_order ON purchase_order.id = po_line.purchaseorderid
        LEFT JOIN folio_invoice.invoice_lines AS invoice_lines ON jsonb_extract_path_text(invoice_lines.jsonb, 'poLineId')::uuid = po_line.id
        LEFT JOIN folio_invoice.invoices AS invoices ON invoices.id = invoice_lines.invoiceid
        LEFT JOIN folio_organizations.organizations AS invoice_organizations ON jsonb_extract_path_text(invoices.jsonb, 'vendorId')::uuid = invoice_organizations.id
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
        folio_finance.fiscal_year AS fiscal_year
        LEFT JOIN folio_finance.ledger AS ledger ON ledger.fiscalyearoneid = fiscal_year.id
        LEFT JOIN folio_finance.fund AS fund ON fund.ledgerid = ledger.id
        LEFT JOIN folio_finance.budget AS budget ON budget.fundid = fund.id
            AND budget.fiscalyearid = fiscal_year.id
),
transactions AS (
    SELECT
        transaction.id AS transaction_id,
        jsonb_extract_path_text(transaction.jsonb, 'fromFundId')::uuid AS fromFundId,
        jsonb_extract_path_text(transaction.jsonb, 'amount')::numeric(19, 4) AS transaction_amount,
        jsonb_extract_path_text(transaction.jsonb, 'currency') AS transaction_currency,
        jsonb_extract_path_text(transaction.jsonb, 'sourceInvoiceLineId')::uuid AS sourceInvoiceLineId,
        jsonb_extract_path_text(transaction.jsonb, 'encumbrance', 'sourcePurchaseOrderId')::uuid AS sourcePurchaseOrderId,
        jsonb_extract_path_text(transaction.jsonb, 'encumbrance', 'sourcePoLineId')::uuid AS sourcePoLineId,
        jsonb_extract_path_text(transaction.jsonb, 'encumbrance', 'initialAmountEncumbered')::numeric(19, 4) AS transaction_encumbrance_initial_amount,
        jsonb_extract_path_text(transaction.jsonb, 'encumbrance', 'amountExpended')::numeric(19, 4) AS transaction_encumbrance_amount_expended,
        jsonb_extract_path_text(transaction.jsonb, 'encumbrance', 'orderType') AS transaction_encumbrance_order_type,
        jsonb_extract_path_text(transaction.jsonb, 'encumbrance', 'subscription')::boolean AS transaction_encumbrance_subscription
    FROM
        folio_finance.transaction AS TRANSACTION
)
SELECT
    orders_invoice.po_id,
    orders_invoice.po_number,
    orders_invoice.po_line_id,
    orders_invoice.po_line_number,
    orders_invoice.po_line_title_or_package,
    orders_invoice.po_line_estimated_price,
    orders_invoice.po_line_fyroAdjustmentAmount,
    orders_invoice.po_line_listUnitPrice,
    orders_invoice.po_line_quantityPhysical,
    orders_invoice.po_line_listUnitPriceElectronic,
    orders_invoice.po_line_quantityElectronic,
    orders_invoice.po_line_additionalCost,
    orders_invoice.po_line_discount,
    orders_invoice.po_line_discountType,
    orders_invoice.po_line_distribution_value,
    orders_invoice.po_line_distribution_type,
    orders_invoice.po_line_currency,
    finance_orders.fiscal_year_id AS po_line_fiscal_year_id,
    finance_orders.fiscal_year AS po_line_fiscal_year,
    finance_orders.ledger_id AS po_line_ledger_id,
    finance_orders.ledger_name AS po_line_ledger_name,
    finance_orders.budget_id AS po_line_budget_id,
    finance_orders.budget_name AS po_line_budget_name,
    finance_orders.fund_id AS po_line_fund_id,
    finance_orders.fund_code AS po_line_fund_code,
    orders_invoice.po_workflowStatus,
    transactions_po_line.transaction_id AS po_line_transaction_id,
    transactions_po_line.transaction_encumbrance_initial_amount,
    transactions_po_line.transaction_encumbrance_amount_expended,
    transactions_po_line.transaction_encumbrance_order_type,
    transactions_po_line.transaction_encumbrance_subscription,
    orders_invoice.invoice_id,
    orders_invoice.folio_invoice_number,
    orders_invoice.vendor_invoice_number,
    orders_invoice.invoice_date,
    orders_invoice.invoice_line_id,
    orders_invoice.invoice_line_distribution_value,
    orders_invoice.invoice_line_distribution_type,
    orders_invoice.invoice_line_total,
    orders_invoice.invoice_currency,
    finance_invoices.fiscal_year_id AS invoice_line_fiscal_year_id,
    finance_invoices.fiscal_year AS invoice_line_fiscal_year,
    finance_invoices.ledger_id AS invoice_line_ledger_id,
    finance_invoices.ledger_name AS invoice_line_ledger_name,
    finance_invoices.budget_id AS invoice_line_budget_id,
    finance_invoices.budget_name AS invoice_line_budget_name,
    finance_invoices.fund_id AS invoice_line_fund_id,
    finance_invoices.fund_code AS invoice_line_fund_code,
    orders_invoice.invoice_vendor_id,
    orders_invoice.invoice_vendor_name,
    orders_invoice.invoice_status,
    orders_invoice.invoice_exchange_rate,
    transactions_inv.transaction_id AS invoice_line_transaction_id,
    transactions_inv.transaction_amount AS invoice_line_transaction_amount,
    transactions_inv.transaction_currency AS invoice_line_transaction_currency
FROM
    orders_invoice
    LEFT JOIN finance AS finance_orders ON finance_orders.fund_id = orders_invoice.po_line_fund_id
    LEFT JOIN finance AS finance_invoices ON finance_invoices.fund_id = orders_invoice.invoice_line_fund_id
    LEFT JOIN transactions AS transactions_po_line ON transactions_po_line.sourcePoLineId = orders_invoice.po_line_id
        AND transactions_po_line.fromFundId = orders_invoice.po_line_fund_id
    LEFT JOIN transactions AS transactions_inv ON transactions_inv.sourceInvoiceLineId = orders_invoice.invoice_line_id
        AND transactions_inv.fromFundId = orders_invoice.invoice_line_fund_id
    ORDER BY
        po_number,
        po_line_number;

CREATE INDEX ON finance_po_inv_transactions (po_id);

CREATE INDEX ON finance_po_inv_transactions (po_number);

CREATE INDEX ON finance_po_inv_transactions (po_line_id);

CREATE INDEX ON finance_po_inv_transactions (po_line_number);

CREATE INDEX ON finance_po_inv_transactions (po_line_title_or_package);

CREATE INDEX ON finance_po_inv_transactions (po_line_estimated_price);

CREATE INDEX ON finance_po_inv_transactions (po_line_fyroAdjustmentAmount);

CREATE INDEX ON finance_po_inv_transactions (po_line_listUnitPrice);

CREATE INDEX ON finance_po_inv_transactions (po_line_quantityPhysical);

CREATE INDEX ON finance_po_inv_transactions (po_line_listUnitPriceElectronic);

CREATE INDEX ON finance_po_inv_transactions (po_line_quantityElectronic);

CREATE INDEX ON finance_po_inv_transactions (po_line_additionalCost);

CREATE INDEX ON finance_po_inv_transactions (po_line_discount);

CREATE INDEX ON finance_po_inv_transactions (po_line_discountType);

CREATE INDEX ON finance_po_inv_transactions (po_line_distribution_value);

CREATE INDEX ON finance_po_inv_transactions (po_line_distribution_type);

CREATE INDEX ON finance_po_inv_transactions (po_line_currency);

CREATE INDEX ON finance_po_inv_transactions (po_line_fiscal_year_id);

CREATE INDEX ON finance_po_inv_transactions (po_line_fiscal_year);

CREATE INDEX ON finance_po_inv_transactions (po_line_ledger_id);

CREATE INDEX ON finance_po_inv_transactions (po_line_ledger_name);

CREATE INDEX ON finance_po_inv_transactions (po_line_budget_id);

CREATE INDEX ON finance_po_inv_transactions (po_line_budget_name);

CREATE INDEX ON finance_po_inv_transactions (po_line_fund_id);

CREATE INDEX ON finance_po_inv_transactions (po_line_fund_code);

CREATE INDEX ON finance_po_inv_transactions (po_workflowStatus);

CREATE INDEX ON finance_po_inv_transactions (po_line_transaction_id);

CREATE INDEX ON finance_po_inv_transactions (transaction_encumbrance_initial_amount);

CREATE INDEX ON finance_po_inv_transactions (transaction_encumbrance_amount_expended);

CREATE INDEX ON finance_po_inv_transactions (transaction_encumbrance_order_type);

CREATE INDEX ON finance_po_inv_transactions (transaction_encumbrance_subscription);

CREATE INDEX ON finance_po_inv_transactions (invoice_id);

CREATE INDEX ON finance_po_inv_transactions (folio_invoice_number);

CREATE INDEX ON finance_po_inv_transactions (vendor_invoice_number);

CREATE INDEX ON finance_po_inv_transactions (invoice_date);

CREATE INDEX ON finance_po_inv_transactions (invoice_line_id);

CREATE INDEX ON finance_po_inv_transactions (invoice_line_distribution_value);

CREATE INDEX ON finance_po_inv_transactions (invoice_line_distribution_type);

CREATE INDEX ON finance_po_inv_transactions (invoice_line_total);

CREATE INDEX ON finance_po_inv_transactions (invoice_currency);

CREATE INDEX ON finance_po_inv_transactions (invoice_line_fiscal_year_id);

CREATE INDEX ON finance_po_inv_transactions (invoice_line_fiscal_year);

CREATE INDEX ON finance_po_inv_transactions (invoice_line_ledger_id);

CREATE INDEX ON finance_po_inv_transactions (invoice_line_ledger_name);

CREATE INDEX ON finance_po_inv_transactions (invoice_line_budget_id);

CREATE INDEX ON finance_po_inv_transactions (invoice_line_budget_name);

CREATE INDEX ON finance_po_inv_transactions (invoice_line_fund_id);

CREATE INDEX ON finance_po_inv_transactions (invoice_line_fund_code);

CREATE INDEX ON finance_po_inv_transactions (invoice_vendor_id);

CREATE INDEX ON finance_po_inv_transactions (invoice_vendor_name);

CREATE INDEX ON finance_po_inv_transactions (invoice_status);

CREATE INDEX ON finance_po_inv_transactions (invoice_exchange_rate);

CREATE INDEX ON finance_po_inv_transactions (invoice_line_transaction_id);

CREATE INDEX ON finance_po_inv_transactions (invoice_line_transaction_amount);

CREATE INDEX ON finance_po_inv_transactions (invoice_line_transaction_currency);

VACUUM ANALYZE finance_po_inv_transactions;

