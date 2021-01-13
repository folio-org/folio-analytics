/**

INVOICES query


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
summary of what was spent by purchase order line ID
	
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
po_lines_detail AS (
SELECT
	pol_detail.id AS pol_id,
	pol_detail.po_line_number AS "po_line_number"

FROM po_lines AS pol_detail

)
/*

)*/
-- End of WITH section


--MAIN QUERY

SELECT 
	invli_detail.po_line_id,
	pol_detail.po_line_number,
	SUM(invli_detail.invoice_line_total) as "invoice_line_total_sum",
	invoice_status
	
FROM invoice_detail AS inv_detail
	
LEFT JOIN invoice_line_detail AS "invli_detail"
ON invli_detail.invoice_line_invoice_id = inv_detail.invoice_id

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


