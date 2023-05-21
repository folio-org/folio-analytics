DROP TABLE IF EXISTS invoice_lines;

CREATE TABLE invoice_lines AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'accountingCode')::varchar(65535) AS accounting_code,
    jsonb_extract_path_text(jsonb, 'comment')::varchar(65535) AS comment,
    jsonb_extract_path_text(jsonb, 'description')::varchar(65535) AS description,
    jsonb_extract_path_text(jsonb, 'invoiceId')::varchar(36) AS invoice_id,
    jsonb_extract_path_text(jsonb, 'invoiceLineNumber')::varchar(65535) AS invoice_line_number,
    jsonb_extract_path_text(jsonb, 'invoiceLineStatus')::varchar(65535) AS invoice_line_status,
    jsonb_extract_path_text(jsonb, 'poLineId')::varchar(36) AS po_line_id,
    jsonb_extract_path_text(jsonb, 'quantity')::bigint AS quantity,
    jsonb_extract_path_text(jsonb, 'releaseEncumbrance')::boolean AS release_encumbrance,
    jsonb_extract_path_text(jsonb, 'subTotal')::numeric(12,2) AS sub_total,
    jsonb_extract_path_text(jsonb, 'subscriptionEnd')::timestamptz AS subscription_end,
    jsonb_extract_path_text(jsonb, 'subscriptionInfo')::varchar(65535) AS subscription_info,
    jsonb_extract_path_text(jsonb, 'subscriptionStart')::timestamptz AS subscription_start,
    jsonb_extract_path_text(jsonb, 'total')::numeric(12,2) AS total,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_invoice.invoice_lines;

ALTER TABLE invoice_lines ADD PRIMARY KEY (id);

CREATE INDEX ON invoice_lines (accounting_code);

CREATE INDEX ON invoice_lines (comment);

CREATE INDEX ON invoice_lines (description);

CREATE INDEX ON invoice_lines (invoice_id);

CREATE INDEX ON invoice_lines (invoice_line_number);

CREATE INDEX ON invoice_lines (invoice_line_status);

CREATE INDEX ON invoice_lines (po_line_id);

CREATE INDEX ON invoice_lines (quantity);

CREATE INDEX ON invoice_lines (release_encumbrance);

CREATE INDEX ON invoice_lines (sub_total);

CREATE INDEX ON invoice_lines (subscription_end);

CREATE INDEX ON invoice_lines (subscription_info);

CREATE INDEX ON invoice_lines (subscription_start);

CREATE INDEX ON invoice_lines (total);

