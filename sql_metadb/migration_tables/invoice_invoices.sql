DROP TABLE IF EXISTS invoice_invoices;

CREATE TABLE invoice_invoices AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'accountingCode')::varchar(65535) AS accounting_code,
    jsonb_extract_path_text(jsonb, 'adjustmentsTotal')::numeric(12,2) AS adjustments_total,
    jsonb_extract_path_text(jsonb, 'approvalDate')::timestamptz AS approval_date,
    jsonb_extract_path_text(jsonb, 'approvedBy')::varchar(36) AS approved_by,
    jsonb_extract_path_text(jsonb, 'batchGroupId')::varchar(36) AS batch_group_id,
    jsonb_extract_path_text(jsonb, 'chkSubscriptionOverlap')::boolean AS chk_subscription_overlap,
    jsonb_extract_path_text(jsonb, 'currency')::varchar(65535) AS currency,
    jsonb_extract_path_text(jsonb, 'disbursementDate')::timestamptz AS disbursement_date,
    jsonb_extract_path_text(jsonb, 'disbursementNumber')::varchar(65535) AS disbursement_number,
    jsonb_extract_path_text(jsonb, 'enclosureNeeded')::boolean AS enclosure_needed,
    jsonb_extract_path_text(jsonb, 'exchangeRate')::numeric(12,2) AS exchange_rate,
    jsonb_extract_path_text(jsonb, 'exportToAccounting')::boolean AS export_to_accounting,
    jsonb_extract_path_text(jsonb, 'folioInvoiceNo')::varchar(65535) AS folio_invoice_no,
    jsonb_extract_path_text(jsonb, 'invoiceDate')::timestamptz AS invoice_date,
    jsonb_extract_path_text(jsonb, 'manualPayment')::boolean AS manual_payment,
    jsonb_extract_path_text(jsonb, 'note')::varchar(65535) AS note,
    jsonb_extract_path_text(jsonb, 'paymentDate')::timestamptz AS payment_date,
    jsonb_extract_path_text(jsonb, 'paymentMethod')::varchar(65535) AS payment_method,
    jsonb_extract_path_text(jsonb, 'paymentTerms')::varchar(65535) AS payment_terms,
    jsonb_extract_path_text(jsonb, 'source')::varchar(65535) AS source,
    jsonb_extract_path_text(jsonb, 'status')::varchar(65535) AS status,
    jsonb_extract_path_text(jsonb, 'vendorId')::varchar(36) AS vendor_id,
    jsonb_extract_path_text(jsonb, 'vendorInvoiceNo')::varchar(65535) AS vendor_invoice_no,
    jsonb_extract_path_text(jsonb, 'voucherNumber')::varchar(65535) AS voucher_number,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_invoice.invoices;

