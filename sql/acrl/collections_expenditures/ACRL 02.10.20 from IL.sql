/* FIELDS TO INCLUDE:
    fiscal year code
    fund code
    fund name
    invoice Line id
    invoice Line total
    invoice Line status
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
        /*'' :: DATE AS invoice_paid_start_date, --ex:2000-01-01
        '' :: DATE AS invoice_end_date, -- ex:2020-12-31*/
		'' :: VARCHAR AS order_type, -- select 'One-Time' or 'Ongoing' or leave blank for both
        '' :: VARCHAR AS order_format, -- select 'Electronic Resource', 'Physical Resource', 'P/E Mix', 'Other' or leave blank for all
		/*'' :: VARCHAR AS fund_id,-- select fund associated with Shipping OR Binding or leave blank for all*/
		'' :: VARCHAR AS material_name, -- select material name as needed, i.e. 'Book', 'DVD', 'Microform' etc.
		'' :: VARCHAR AS institution_name, -- select institution name'Københavns Universitet','Montoya College'
        '' :: VARCHAR AS campus_name, -- select Campus 'Main Campus','City Campus','Online'
        '' :: VARCHAR AS library_name, -- select 'Datalogisk Institut','Adelaide Library'
        '' :: VARCHAR AS location_name -- 'Main Library','Annex','Online' 
),
location_filtering AS (
    SELECT 
        p.id AS pieces_id,
        loc.name AS location_name,
        libraries.name AS library_name,
	    --loc.campus_id AS campus_id, -- not used
	    campuses.name AS campus_name,
	    --loc.institution_id AS institution_id, -- not used
	    institutions.name AS institution_name,
	    mat.name AS material_types_name
	 FROM pieces AS p
	     LEFT JOIN items AS it 
	         ON it.id = p.item_id
         LEFT JOIN locations AS loc
             ON p.location_id = loc.id
         LEFT JOIN libraries
             ON loc.library_id = libraries.id
         LEFT JOIN campuses
             ON loc.campus_id = campuses.id
         LEFT JOIN institutions
             ON loc.institution_id = institutions.id
         LEFT JOIN material_types AS mat
             ON it.MATERIAL_TYPE_ID = mat.id
      WHERE 
          (institutions.name = (SELECT institution_name FROM parameters) OR (SELECT institution_name FROM parameters) = '')
          AND 
          (campuses.name = (SELECT campus_name FROM parameters) OR (SELECT campus_name FROM parameters) = '')
          AND 
          (libraries.name = (SELECT library_name FROM parameters) OR (SELECT library_name FROM parameters) = '')
          AND 
          (loc.name = (SELECT location_name FROM parameters) OR (SELECT location_name FROM parameters) = '')
          AND 
          (mat.name = (SELECT material_name FROM parameters) OR (SELECT material_name FROM parameters) = '')
      GROUP BY loc.name, libraries.name, campuses.name, institutions.name, mat.name,p.id
)
--Main Query--
SELECT
    il.id AS invoice_line_id,
    p.id AS pieces_id,
    location_filtering.location_name AS loc_name,
    location_filtering.library_name AS lib_name,
    location_filtering.campus_name AS camp_name,
    location_filtering.institution_name AS instut_name,
    location_filtering.material_types_name AS material_types_name,
    SUM(il.total) AS total_il,
    /*il.accounting_code AS accounting_code_from_il,*/ --NOT IN LDP AS OF 02.10.2020
    f.code AS fund_code,
    il.INVOICE_LINE_STATUS AS invoice_line_status,
    o.order_type AS order_type,
    pol.order_format AS order_format,
    fy.code
    /*pol.id AS po_lines_id*/--Not needed at this point
    /*p.id*/--Not needed at this point
 FROM invoice_lines AS il
     LEFT JOIN po_lines AS pol
         ON pol.id = il.po_line_id
     LEFT JOIN pieces AS p 
         ON p.po_line_id = pol.id 
     RIGHT JOIN location_filtering
         ON p.id = location_filtering.pieces_id 
     LEFT JOIN orders AS o 
         ON pol.purchase_order_id = o.id
     LEFT JOIN transactions AS t 
         ON t.SOURCE_INVOICE_LINE_ID = il.id
     LEFT JOIN funds AS f 
         ON f.id = t.TO_FUND_ID
     LEFT JOIN FISCAL_YEARS AS fy 
         ON fy.id = t.FISCAL_YEAR_ID
    /*LEFT JOIN invoices AS i
        ON i.id = il.invoice_id*/--Not needed at this point
WHERE il.invoice_line_status LIKE 'Paid'
    AND 
    (fy.code = (SELECT Fiscal_Year FROM parameters) OR (SELECT Fiscal_Year FROM parameters) = '')
    AND
    (order_type = (SELECT order_type FROM parameters) OR (SELECT order_type FROM parameters) = '')
    AND 
   (order_format= (SELECT order_format FROM parameters) OR (SELECT order_format FROM parameters) = '')
GROUP BY 
    il.id,
    p.id,
    location_filtering.location_name,
    location_filtering.library_name,
    location_filtering.campus_name,
    location_filtering.institution_name,
    location_filtering.material_types_name,
    il.total,
    /*il.accounting_code,*/--NOT IN LDP AS OF 02.10.2020
    f.code,
    il.INVOICE_LINE_STATUS,
    o.order_type,
    pol.order_format,
    fy.code
   
  