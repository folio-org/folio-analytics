-- The report shows the fund distribution by fiscal years. 
-- Amounts are calculated from invoice lines in system currency and invoice status is paid. At the same time, the invoice lines must be connected to an agreement line.
WITH parameters AS (
    SELECT
        --specify interval for fiscal years in YYYY-MM-DD format
        --'2018-01-01'::date AS start_date,
        --'2022-12-31'::date AS end_date
        --
        -- use null values to show all fiscal years
        NULL::date AS start_date,
        NULL::date AS end_date
)
SELECT
    funds.invoice_line_fiscal_year_id AS fy_id,
    fy.period_start::timestamptz AS fy_start,
    fy.period_end::timestamptz AS fy_end,
    funds.invoice_line_fiscal_year AS fy_code,
    funds.invoice_line_fund_code AS fund_code,
    sum(funds.invoice_line_transaction_amount)::numeric(19, 4) AS amount_paid
FROM
    folio_derived.agreements_subscription_agreement_entitlement AS agreements
    JOIN folio_derived.finance_po_inv_transactions AS funds ON funds.po_line_id = agreements.po_line_id
    JOIN folio_finance.fiscal_year__t AS fy ON fy.id = funds.invoice_line_fiscal_year_id
WHERE 
    funds.invoice_status = 'Paid'
    AND 
    ((fy.period_start::date >= (SELECT start_date FROM parameters) AND fy.period_end::date <= (SELECT end_date FROM parameters)) 
    OR (((SELECT start_date FROM parameters) IS NULL) OR ((SELECT end_date FROM parameters) IS NULL)))	
GROUP BY 
    fy_id,
    fy_code,
    fund_code,
    fy_start,
    fy_end
ORDER BY 
    fy_code;
