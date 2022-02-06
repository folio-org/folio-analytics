DROP TABLE IF EXISTS finance_transactions;

CREATE TABLE finance_transactions AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'amount')::numeric(12,2) AS amount,
    jsonb_extract_path_text(jsonb, 'currency')::varchar(65535) AS currency,
    jsonb_extract_path_text(jsonb, 'description')::varchar(65535) AS description,
    jsonb_extract_path_text(jsonb, 'expenseClassId')::varchar(36) AS expense_class_id,
    jsonb_extract_path_text(jsonb, 'fiscalYearId')::varchar(36) AS fiscal_year_id,
    jsonb_extract_path_text(jsonb, 'fromFundId')::varchar(36) AS from_fund_id,
    jsonb_extract_path_text(jsonb, 'paymentEncumbranceId')::varchar(36) AS payment_encumbrance_id,
    jsonb_extract_path_text(jsonb, 'source')::varchar(65535) AS source,
    jsonb_extract_path_text(jsonb, 'sourceFiscalYearId')::varchar(36) AS source_fiscal_year_id,
    jsonb_extract_path_text(jsonb, 'sourceInvoiceId')::varchar(36) AS source_invoice_id,
    jsonb_extract_path_text(jsonb, 'sourceInvoiceLineId')::varchar(36) AS source_invoice_line_id,
    jsonb_extract_path_text(jsonb, 'toFundId')::varchar(36) AS to_fund_id,
    jsonb_extract_path_text(jsonb, 'transactionType')::varchar(65535) AS transaction_type,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_finance.transaction;

ALTER TABLE finance_transactions ADD PRIMARY KEY (id);

CREATE INDEX ON finance_transactions (amount);

CREATE INDEX ON finance_transactions (currency);

CREATE INDEX ON finance_transactions (description);

CREATE INDEX ON finance_transactions (expense_class_id);

CREATE INDEX ON finance_transactions (fiscal_year_id);

CREATE INDEX ON finance_transactions (from_fund_id);

CREATE INDEX ON finance_transactions (payment_encumbrance_id);

CREATE INDEX ON finance_transactions (source);

CREATE INDEX ON finance_transactions (source_fiscal_year_id);

CREATE INDEX ON finance_transactions (source_invoice_id);

CREATE INDEX ON finance_transactions (source_invoice_line_id);

CREATE INDEX ON finance_transactions (to_fund_id);

CREATE INDEX ON finance_transactions (transaction_type);

VACUUM ANALYZE finance_transactions;
