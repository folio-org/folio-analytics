DROP TABLE IF EXISTS invoice_voucher_lines;

CREATE TABLE invoice_voucher_lines AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'amount')::numeric(12,2) AS amount,
    jsonb_extract_path_text(jsonb, 'externalAccountNumber')::varchar(65535) AS external_account_number,
    jsonb_extract_path_text(jsonb, 'voucherId')::varchar(36) AS voucher_id,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_invoice.voucher_lines;

ALTER TABLE invoice_voucher_lines ADD PRIMARY KEY (id);

CREATE INDEX ON invoice_voucher_lines (amount);

CREATE INDEX ON invoice_voucher_lines (external_account_number);

CREATE INDEX ON invoice_voucher_lines (voucher_id);

