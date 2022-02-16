DROP TABLE IF EXISTS invoice_voucher_lines_fund_distributions;
-- Create a derived table to extract fund_distributions from invoice_voucher_lines and joining funds related tables
CREATE TABLE invoice_voucher_lines_fund_distributions AS

WITH funds_distr AS (
	SELECT
    	id AS invoice_voucher_line_id,
        jsonb_extract_path_text(dist.data, 'code') AS fund_distribution_code,
        jsonb_extract_path_text(dist.data, 'fundId')::uuid AS fund_distribution_id,
        jsonb_extract_path_text(dist.data, 'invoiceLineId')::uuid AS fund_distribution_invl_id,
        jsonb_extract_path_text(dist.data, 'expenseClassId')::uuid AS fund_distribution_expense_class_id,
        jsonb_extract_path_text(dist.data, 'value')::numeric(19,4) AS fund_distribution_value,
        jsonb_extract_path_text(invvl.jsonb, 'amount')::numeric(19,4) AS invoice_voucher_lines_amount,
        jsonb_extract_path_text(dist.data, 'distributionType') AS fund_distribution_type,
        jsonb_extract_path_text(invvl.jsonb, 'externalAccountNumber') AS invoice_voucher_lines_external_account_number,
        voucherid AS voucher_id
    FROM
        folio_invoice.voucher_lines AS invvl
        CROSS JOIN jsonb_array_elements(jsonb_extract_path(invvl.jsonb, 'fundDistributions')) AS dist(data)
)
SELECT
	invoice_voucher_line_id AS invoice_voucher_line_id,
    voucher_id AS voucher_id,
    invv.voucher_number AS voucher_number,
    invoice_voucher_lines_amount AS invoice_voucher_lines_amount,
    fund_distribution_type AS fund_distribution_type,
    fund_distribution_id AS fund_distribution_id,
    fund_distribution_code AS fund_distribution_code,
    ff.name AS fund_name,
    fund_distribution_invl_id AS fund_distribution_invl_id,
    fund_distribution_expense_class_id AS fund_distribution_expense_class_id,
    fec.name AS expense_class_name,
    fund_distribution_value AS fund_distribution_value,
    ff.fund_status AS fund_status,
    ff.fund_type_id::uuid AS fund_type_id,
    ft.name AS fund_type_name,
    --ff.tags,  Take out '--' when tags are available to add to this query
    invoice_voucher_lines_external_account_number AS invoice_voucher_lines_external_account_number   
FROM
    funds_distr
    LEFT JOIN folio_finance.fund__t AS ff ON ff.id = funds_distr.fund_distribution_id
    LEFT JOIN folio_finance.fund_type__t AS ft ON ft.id = ff.fund_type_id::uuid
    LEFT JOIN folio_finance.expense_class__t AS fec ON fec.id = fund_distribution_expense_class_id
    LEFT JOIN folio_invoice.vouchers__t AS invv ON invv.id = funds_distr.voucher_id
ORDER BY voucher_number;
   
CREATE INDEX ON invoice_voucher_lines_fund_distributions (invoice_voucher_line_id);

CREATE INDEX ON invoice_voucher_lines_fund_distributions (voucher_id);

CREATE INDEX ON invoice_voucher_lines_fund_distributions (voucher_number);

CREATE INDEX ON invoice_voucher_lines_fund_distributions (invoice_voucher_lines_amount);

CREATE INDEX ON invoice_voucher_lines_fund_distributions (fund_distribution_type);

CREATE INDEX ON invoice_voucher_lines_fund_distributions (fund_distribution_id);

CREATE INDEX ON invoice_voucher_lines_fund_distributions (fund_distribution_code);

CREATE INDEX ON invoice_voucher_lines_fund_distributions (fund_name);

CREATE INDEX ON invoice_voucher_lines_fund_distributions (fund_distribution_invl_id);

CREATE INDEX ON invoice_voucher_lines_fund_distributions (fund_distribution_expense_class_id);

CREATE INDEX ON invoice_voucher_lines_fund_distributions (expense_class_name);

CREATE INDEX ON invoice_voucher_lines_fund_distributions (fund_distribution_value);

CREATE INDEX ON invoice_voucher_lines_fund_distributions (fund_status);

CREATE INDEX ON invoice_voucher_lines_fund_distributions (fund_type_id);

CREATE INDEX ON invoice_voucher_lines_fund_distributions (fund_type_name);

CREATE INDEX ON invoice_voucher_lines_fund_distributions (invoice_voucher_lines_external_account_number);

VACUUM ANALYZE invoice_voucher_lines_fund_distributions;

