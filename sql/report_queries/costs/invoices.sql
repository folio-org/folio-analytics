/**

PURPOSE

This query provides a summary of what was spent by purchase order line  
on an invoice line across all the invoices within a particular time period. 
Invoice line adjustments are included in the invoice line total. 
This query only shows invoice line data that is linked to a purchase order.

MAIN TABLES AND COLUMNS INCLUDED

-invoice_invoices
	-id
	-approvalDate (stand-in for datePaid)
	-total
	
-invoice_lines
	-id
	-total
	-subtotal
	-invoice_id
	-invoice_line_number
	-po_line_id
	
-po_lines
	-id
	-po number
	
-po_order_invoice_relns
	-id
	-invoice_id
	-purchase_order_id
	
	
AGGREGATION
summary of what was spent by purchase order line ID. 
	
FILTERS FOR USERS TO SELECT
invoice date
invoice status

STILL IN PROGRESS
						
The datePaid data element will not be available until R1-2021 and it is needed for this query.	
		

NOTE
There must be a po line for every invoice line.							
					
*/

WITH parameters AS (
    SELECT
        '2000-01-01' :: DATE AS start_date,
        '2021-01-01' :: DATE AS end_date,
        'Paid' :: VARCHAR AS invoice_status  -- Enter your status eg. Paid, Approved, etc.
),

--subquery for invoice detail
 invoice_detail AS (
SELECT
	inv.id AS "invoice_id",
	inv.approval_date AS "invoice_approval_date",
	inv.total AS "invoice_total",
	inv.status AS "invoice_status"
	
FROM invoice_invoices AS inv
),


--subquery for invoice line detail

invoice_line_detail AS (
SELECT
	invli.po_line_id AS "po_line_id",
	invli.id AS "invoice_line_id",
	invli.sub_total AS "invoice_line_sub_total",
	invli.total AS "invoice_line_total",
	invli.invoice_line_number AS "invoice_line_number",
	invli.invoice_id AS "invoice_line_invoice_id"
	
FROM invoice_lines AS invli

),
--subquery for po line number
--use po_line_id in invoice_lines to join to po_lines, get po_line_number from po_lines

po_lines_detail AS (
SELECT
	pol_detail.id AS pol_id,
	pol_detail.po_line_number AS "po_line_number"

FROM po_lines AS pol_detail

)
/*

)*/
-- End of WITH section


--MAIN QUERY: 
--summarize invoices by invoice line total, grouping by po_line_id, 
--show how much was spent per PO for a given time period
--we only want the po lines that appear in invoice lines

SELECT 
	invli_detail.po_line_id,
	pol_detail.po_line_number,
	SUM(invli_detail.invoice_line_total) as "invoice_line_total_sum",
	invoice_status
	
FROM invoice_detail AS inv_detail
	
LEFT JOIN invoice_line_detail AS "invli_detail"
ON invli_detail.invoice_line_invoice_id = inv_detail.invoice_id
--pull the purchase order related data by joining tables
LEFT JOIN po_lines_detail AS pol_detail
	ON invli_detail.po_line_id = pol_detail.pol_id
WHERE
	inv_detail.invoice_status = (SELECT invoice_status FROM parameters)
	AND (inv_detail.invoice_approval_date > (SELECT start_date FROM parameters) 
	AND inv_detail.invoice_approval_date < (SELECT end_date FROM parameters))
GROUP BY
	invli_detail.po_line_id,
	pol_detail.po_line_number,
	inv_detail.invoice_status;



--invoice_line_total shows total for each line on the invoice, regardless of what fund is charged
--invoice_total shows the invoice line totals plus any additional charges that are not prorated across the invoice line (e.g., shipping)
--there can be more than one invoice per po line

--ADD
--expense type set at the invoice line; pull from the invoice line table; make it available as filter
--you can have 2 different expense types on the same po line, so need to think about how to aggregate
--Add StartDate and EndDate for subscriptions
--subscription_start subscription_end
--subscription_info would be non-date related data for subscriptions (such as v.31 or no.10, etc.)  
--These are all from invoice_lines

	
	

				
		
	
	


