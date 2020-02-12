/* FIELDS TO INCLUDE:
    fiscal year code
    budget id
    budget name
    fund id
    fund name
    fund_type_name
    invoice id
    invoice total
    invoice status
    order id
    order type
    order format
    material format name
    location name
    library name
    campus name 
    institution name
    
    Aggregation: Invoice Total Amount
    (the report is asking for the sum of all payments per fiscal year)
*/
/* Change the lines below to filter or leave blank to return all results. Add details in '' for a specific filter*/
WITH parameters AS (
    SELECT
       '' :: VARCHAR AS fiscal_year, -- 'FY2019','FY2020', etc
	   '' :: VARCHAR AS order_type, -- select 'One-Time' or 'Ongoing' or leave blank for both
       '' :: VARCHAR AS order_format, -- select 'Electronic Resource', 'Physical Resource', 'P/E Mix', 'Other' or leave blank for all
	   '' :: VARCHAR AS fund_id,-- select fund associated with Shipping OR Binding or leave blank for all
	   '' :: VARCHAR AS material_name, -- select material name as needed, i.e. 'Book', 'DVD', 'Microform' etc.
	   '' :: VARCHAR AS institution_name, -- select institution name'KÃ¸benhavns Universitet','Montoya College'
       '' :: VARCHAR AS campus_name, -- select Campus 'Main Campus','City Campus','Online'
       '' :: VARCHAR AS library_name, -- select 'Datalogisk Institut','Adelaide Library'
       '' :: VARCHAR AS location_name -- 'Main Library','Annex','Online' etc.
)
SELECT 
    i.id AS invoice_id,
    i.total AS invoice_total_amount, 
    /* Invoice total seems like the key field, since ACRL eventually wants as total for all expenditures (I believe).
     * But in this report, we can have invoice repeated over multiple rows, because we're connecting to invoice
     * lines, and then po_lines, then pieces, etc. All of those may be helpful for context, but each join
     * has the potential to duplicate the expenditure amount.
     * 
     * So, a few questions:
     * - do we want to try to produce a report where the "amount" column can just be summed to create the 
     *   desired total?
     * - is invoice the right place to get the amount? even if the invoice isn't fully paid, is there a chance 
     *   that there have been some "payment" transactions on that invoice in the correct time period?
     * 
     * Also, I think transactions can connect to invoice lines directly. if so, this query could connect
     * transactions straight to invoice lines, pull the amount from the transaction, and use the 
     * transaction type to filter to payments.  
     */ 
    i.status AS invoice_status,
    il.id AS invoice_line_id,
    o.order_type AS order_type,
    pol.order_format AS order_format,
    mat.name AS material_type_name,
    fy.code AS fiscal_year_code,
    --f.id AS fund_id, --not sure we need the fund id, if we have the name
    f.name AS fund_name,
    ft.name AS fund_type_name,
    loc."name" AS loc_name,
    libraries."name" AS lib_name,
    campuses."name" AS camp_name,
    institutions."name" AS instution_name
FROM invoice_lines AS il
LEFT JOIN invoices AS i 
    ON il.invoice_id = i.id
LEFT join po_lines AS pol
    ON il.po_line_id = pol.id
LEFT JOIN transactions AS t 
    ON i.id = t.source_invoice_id 
LEFT JOIN funds AS f 
    ON t.from_fund_id = f.id 
LEFT JOIN fund_types AS ft 
    ON f.fund_type_id = ft.id
LEFT JOIN budgets AS b 
    ON f.id = b.fund_id
LEFT JOIN fiscal_years AS fy
    ON b.fiscal_year_id = fy.id 
LEFT join pieces as p
    ON pol.id = p.po_line_id  
LEFT JOIN orders AS o 
    ON pol.purchase_order_id = o.id
LEFT JOIN items it
    ON p.item_id = it.id
LEFT JOIN material_types AS mat
    ON it.material_type_id = mat.id 
LEFT JOIN locations AS loc
    ON p.location_id = loc.id
LEFT JOIN libraries
    ON loc.library_id = libraries.id
LEFT JOIN campuses
    ON loc.campus_id = campuses.id
LEFT JOIN institutions
    ON loc.institution_id = institutions.id
WHERE 
    invoice_line_status = 'Paid' ---- We only want to see paid items as this report is for expenditures----
   AND
       (fy.code = (SELECT fiscal_year FROM parameters) OR (SELECT fiscal_year FROM parameters) = '')
   AND 
       (order_type = (SELECT order_type FROM parameters) OR (SELECT order_type FROM parameters) = '')
   AND 
       (order_format= (SELECT order_format FROM parameters) OR (SELECT order_format FROM parameters) = '')
   AND 
       (fund_id = (SELECT fund_id FROM parameters) OR (SELECT fund_id FROM parameters) = '')
   AND 
       (institutions.name = (SELECT institution_name FROM parameters) OR (SELECT institution_name FROM parameters) = '')
   AND 
       (campuses.name = (SELECT campus_name FROM parameters) OR (SELECT campus_name FROM parameters) = '')
   AND 
       (libraries.name = (SELECT library_name FROM parameters) OR (SELECT library_name FROM parameters) = '')
   AND 
       (loc.name = (SELECT location_name FROM parameters) OR (SELECT location_name FROM parameters) = '')
   AND 
       (mat.name = (SELECT material_name FROM parameters) OR (SELECT material_name FROM parameters) = '')
