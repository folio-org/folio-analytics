DROP TABLE IF EXISTS invoice_vouchers;

CREATE TABLE invoice_vouchers AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'accountingCode')::varchar(65535) AS accounting_code,
    jsonb_extract_path_text(jsonb, 'amount')::numeric(12,2) AS amount,
    jsonb_extract_path_text(jsonb, 'batchGroupId')::varchar(36) AS batch_group_id,
    jsonb_extract_path_text(jsonb, 'disbursementAmount')::numeric(12,2) AS disbursement_amount,
    jsonb_extract_path_text(jsonb, 'disbursementDate')::timestamptz AS disbursement_date,
    jsonb_extract_path_text(jsonb, 'disbursementNumber')::varchar(65535) AS disbursement_number,
    jsonb_extract_path_text(jsonb, 'enclosureNeeded')::boolean AS enclosure_needed,
    jsonb_extract_path_text(jsonb, 'exchangeRate')::numeric(12,2) AS exchange_rate,
    jsonb_extract_path_text(jsonb, 'exportToAccounting')::boolean AS export_to_accounting,
    jsonb_extract_path_text(jsonb, 'invoiceCurrency')::varchar(65535) AS invoice_currency,
    jsonb_extract_path_text(jsonb, 'invoiceId')::varchar(36) AS invoice_id,
    jsonb_extract_path_text(jsonb, 'status')::varchar(65535) AS status,
    jsonb_extract_path_text(jsonb, 'systemCurrency')::varchar(65535) AS system_currency,
    jsonb_extract_path_text(jsonb, 'type')::varchar(65535) AS type,
    jsonb_extract_path_text(jsonb, 'vendorId')::varchar(36) AS vendor_id,
    jsonb_extract_path_text(jsonb, 'voucherDate')::timestamptz AS voucher_date,
    jsonb_extract_path_text(jsonb, 'voucherNumber')::varchar(65535) AS voucher_number,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_invoice.vouchers;

ALTER TABLE invoice_vouchers ADD PRIMARY KEY (id);

CREATE INDEX ON invoice_vouchers (accounting_code);

CREATE INDEX ON invoice_vouchers (amount);

CREATE INDEX ON invoice_vouchers (batch_group_id);

CREATE INDEX ON invoice_vouchers (disbursement_amount);

CREATE INDEX ON invoice_vouchers (disbursement_date);

CREATE INDEX ON invoice_vouchers (disbursement_number);

CREATE INDEX ON invoice_vouchers (enclosure_needed);

CREATE INDEX ON invoice_vouchers (exchange_rate);

CREATE INDEX ON invoice_vouchers (export_to_accounting);

CREATE INDEX ON invoice_vouchers (invoice_currency);

CREATE INDEX ON invoice_vouchers (invoice_id);

CREATE INDEX ON invoice_vouchers (status);

CREATE INDEX ON invoice_vouchers (system_currency);

CREATE INDEX ON invoice_vouchers (type);

CREATE INDEX ON invoice_vouchers (vendor_id);

CREATE INDEX ON invoice_vouchers (voucher_date);

CREATE INDEX ON invoice_vouchers (voucher_number);

