/**
INVOICES Prorated Adjustments Report

This purpose of this report is to provide a summary of what was spent by purchase order line on an invoice line 
across all the invoices within a particular time period. Prorated invoice line adjustments are included in the invoice line total. 
The "invoice_line_total_sum" column shows the sum of invoice line totals associated with each purchase order line number. 
This query only shows invoice line data that is linked to a purchase order. Note that there must be a po line for every invoice line.
The results are aggregated by purchase order line id, purchase order line number, invoice_line_total_sum, invoice status, 
and invoice payment date, and vendor invoice number. Results may be filtered by invoice payment date and invoice status. The invoice line total calculations 
include everything except non-prorated adjustments to invoices at the invoice level.  

MAIN TABLES AND COLUMNS INCLUDED

-invoice_invoices
 -id
 -payment_date
 -status
 -vendor_invoice_no

-invoice_lines
 -id
 -invoice_id
 -invoice_line_number
 -po_line_id

-po_lines
 -id
 -po_line_number
	
-po_order_invoice_relns
 -id
 -invoice_id
 -purchase_order_id

-finance_transaction_invoices
 -transaction_amount
	
AGGREGATION
po_line_id, po_line_number, invoice_status, invoice_payment_date, vendor_invoice_number
	
FILTERS FOR USERS TO SELECT
invoice_payment_date, invoice_status
 */
WITH parameters AS (
    SELECT
        /* enter invoice payment start date and end date in YYYY-MM-DD format */
        --'2000-01-01' :: DATE AS start_date,
        --'2021-01-01' :: DATE AS end_date,
        /* enter invoice_status as Open, Reviewed, Approved, Paid or Cancelled */
        --'' :: VARCHAR AS invoice_status
),
--subquery for invoice detail
invoice_detail AS (
    SELECT
        inv.id AS "invoice_id",
        inv.payment_date AS "invoice_payment_date",
        inv.status AS "invoice_status",
        inv.vendor_invoice_no AS "vendor_invoice_number"
    FROM
        invoice_invoices AS inv
),
--subquery for invoice line detail
invoice_line_detail AS (
    SELECT
        invli.po_line_id AS "po_line_id",
        invli.id AS "invoice_line_id",
        invli.invoice_line_number AS "invoice_line_number",
        invli.invoice_id AS "invoice_line_invoice_id"
    FROM
        invoice_lines AS invli
),
--subquery for po line number
po_lines_detail AS (
    SELECT
        pol_detail.id AS pol_id,
        pol_detail.po_line_number AS "po_line_number"
    FROM
        po_lines AS pol_detail)
--End of WITH section
--MAIN QUERY
SELECT
    invli_detail.po_line_id,
    pol_detail.po_line_number,
    sum(fitrin.transaction_amount) AS "invoice_line_total_sum",
    invoice_status,
    inv_detail.invoice_payment_date::date,
    inv_detail.vendor_invoice_number
FROM
    invoice_detail AS inv_detail
    LEFT JOIN invoice_line_detail AS "invli_detail" ON invli_detail.invoice_line_invoice_id = inv_detail.invoice_id
    LEFT JOIN folio_reporting.finance_transaction_invoices AS fitrin ON fitrin.invoice_line_id = invli_detail.invoice_line_id
    LEFT JOIN po_lines_detail AS pol_detail ON invli_detail.po_line_id = pol_detail.pol_id
WHERE
    inv_detail.invoice_status = (SELECT invoice_status FROM parameters)
    --AND (inv_detail.invoice_payment_date > (SELECT start_date FROM parameters)
    --AND inv_detail.invoice_payment_date < (SELECT end_date FROM parameters))
GROUP BY
    invli_detail.po_line_id,
    pol_detail.po_line_number,
    inv_detail.invoice_status,
    inv_detail.invoice_payment_date,
    inv_detail.vendor_invoice_number;

