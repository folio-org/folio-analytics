/* FIELDS TO INCLUDE:
    Invoice Line table:
        invoice Line id
        invoice line subtotal
        invoice line adjustments total
        invoice Line total
        invoice Line status
        invoice Line adjustments description -- Hoping to be able to capture tax information
        invoice disbursement date  -- Using disbursement date since "paid date" is not available yet in the invoice table
        fiscal year code -- Not available yet through the invoice table but in the query if it becomes available
    Order Table:
        order type format
        order type
    PO Line Table:
        purchase order line material type (ER and physical)
        purchase order line locations
        purchase order line fund code
 */  
 /* Change the lines below to filter or leave blank to return all results. Add details in '' for a specific filter. The date filter cannot be left blank but is commented out since data is not available yet*/
WITH parameters AS (
SELECT
        /*'' :: VARCHAR AS Fiscal_Year, -- 'FY2019','FY2020' etc. Data not availabke as of 02.14.2020 */
        '2000-01-01' :: DATE AS approval_date_start_date, --ex:2000-01-01
        '2020-01-01' :: DATE AS approval_date_end_date, -- ex:2020-12-31
        '' :: VARCHAR AS order_type, -- select 'One-Time' or 'Ongoing' or leave blank for both
        '' :: VARCHAR AS order_format, -- select 'Electronic Resource', 'Physical Resource', 'P/E Mix', 'Other' or leave blank for all
        '' :: VARCHAR AS er_mat_type, -- select 'ER material type' or leave blank for all
        '' :: VARCHAR AS phy_mat_type, -- select 'Physical material type' or leave blank for all
        '' :: VARCHAR AS pol_fund_distribution_code
),   
temp_material_types AS (
    SELECT
        id,
        json_extract_path_text(pol.data, 'eresource', 'materialType') AS er_mat_type,
        json_extract_path_text(pol.data, 'physical', 'materialType') AS phy_mat_type
    FROM
        po_lines AS pol
)
--Main Query--
SELECT
    pol.id AS pol_id,
    il.id AS invoice_line_id,
    il.invoice_line_status AS invoice_line_status,
    i.approval_date AS invoice_approval_date,
    il.sub_total AS il_subtotal,
    il.adjustments_total AS il_adjustments_total,
    il.total AS invoice_line_total,
    json_extract_path_text(il.data, 'adjustments', 'description') AS adjustments_description,-- shoudl be able to see the description, like tax, fees etc.
    o.order_type AS order_type,
    pol.order_format AS order_format,
    m1.er_mat_type AS pol_eresource_material_type,
    m1.phy_mat_type AS pol_physical_mat_type_name,
    json_extract_path_text(il.data, 'fundDistributions','code') AS pol_fund_distribution_code, 
    json_extract_path_text(pol.data, 'locations', 'description') AS pol_location_description -- May have to adjust depending of results. Not sure if it is sufficient.
    /*fiscal_year*/-- GET THIS FROM INVOICE, NOT AVAILABLE YET
--
FROM invoice_lines AS il
    LEFT JOIN po_lines AS pol
        ON pol.id = il.po_line_id
    LEFT JOIN orders AS o
        ON pol.purchase_order_id = o.id
    LEFT JOIN temp_material_types AS m1
        ON m1.id = pol.id
    LEFT JOIN invoices AS i
        ON i.id = il.invoice_id  --Not needed at this point
--
WHERE il.invoice_line_status LIKE 'Paid'
    AND
    (order_type = (SELECT order_type FROM parameters) OR (SELECT order_type FROM parameters) = '')
    AND
    (order_format= (SELECT order_format FROM parameters) OR (SELECT order_format FROM parameters) = '')
    AND 
    (er_mat_type= (SELECT er_mat_type FROM parameters) OR (SELECT er_mat_type FROM parameters) = '') 
    AND 
    (phy_mat_type= (SELECT phy_mat_type FROM parameters) OR (SELECT phy_mat_type FROM parameters) = '')
    AND 
    (json_extract_path_text(il.data, 'fundDistributions','code')= (SELECT pol_fund_distribution_code FROM parameters) OR (SELECT pol_fund_distribution_code FROM parameters) = '')
    AND 
    (i.approval_date >= (SELECT approval_date_start_date FROM parameters)) 
    AND 
    (i.approval_date < (SELECT approval_date_end_date FROM parameters)) 
 --
 GROUP BY
    il.invoice_line_status,
    i.approval_date,
    o.order_type,
    pol.order_format,
    pol.id,
    il.id,
    il.sub_total,
    il.adjustments_total,
    il.total,
    json_extract_path_text(il.data, 'adjustments', 'description'),
    m1.er_mat_type,
    m1.phy_mat_type,
    json_extract_path_text (il.data, 'fundDistributions','code'),
    json_extract_path_text (pol.data, 'locations', 'description'),
    json_extract_path_text(i.data, 'disbursementDate')
