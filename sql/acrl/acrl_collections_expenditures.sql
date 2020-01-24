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
        '' :: VARCHAR AS Fiscal_Year, -- 'FY2019','FY2020', etc
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
    i.status AS invoice_status,
    il.id AS invoice_line_id,
    o.order_TYPE AS order_type,
    pol.order_format AS order_format,
    mat.name AS material_type_name,
    fy.code AS fiscal_year_code,
    f.id AS fund_id,
    f.name AS fund_name,
    ft.name AS fund_type_name,
    loc."name" AS loc_name,
    libraries."name" AS lib_name,
    campuses."name" AS camp_name,
    institutions."name" AS instution_name
FROM INVOICE_LINES AS il
    LEFT JOIN invoices AS i 
        ON i.id = il.invoice_id
    LEFT join PO_LINES AS pol
        ON il.po_line_id = pol.id
    LEFT JOIN transactions AS T 
   	ON t.source_invoice_id = i.id
    LEFT JOIN funds AS f 
        ON f.id = t.from_fund_id
    LEFT JOIN fund_types AS ft 
        ON f.fund_type_id = ft.id
    LEFT JOIN budgets AS b 
        ON b.fund_id = f.id
    LEFT JOIN FISCAL_YEARS AS fy
        ON fy.id = b.fiscal_year_id
    LEFT join pieces as p
        ON p.po_line_id = pol.id 
    LEFT JOIN orders AS o 
        ON pol.purchase_order_id = o.id
    LEFT JOIN ITEMS it
        ON p.item_id = it.ID
    LEFT JOIN MATERIAL_TYPES AS mat
        ON mat.id = it.material_type_id
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
       (fy.code = (SELECT Fiscal_Year FROM parameters) OR (SELECT Fiscal_Year FROM parameters) = '')
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
