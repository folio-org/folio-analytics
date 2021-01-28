/** Documentation of ERM INVENTORY COUNT QUERY

DERIVED TABLES
folio_reporting.invoice_adjustments_ext AS inv_adj
folio_reporting.po_lines_phys_mat_type
folio_reporting.po_lines_er_mat_type
folio_reporting.invoice_lines_adjustments
folio_reporting.instance_subjects
folio_reporting.instance_formats
folio_reporting.instance_ext
folio_reporting.holdings_ext
folio_reporting.locations_libraries

TABLES
invoice_invoices
invoice_lines
po_lines

FILTERS: FOR USERS TO SELECT
approval_date (will be paymentdate if available), invoice_line_status, po_line_order_format, instance_subject, mode_of_issuance_name,
format_name, library_name

STILL IN PROGRESS

The paymentdate element will not be available until R1-2021 and it is needed for this query.
 */
WITH parameters AS (
    SELECT
        -- filters on invoice level
        -- Please comment/uncomment one pair the these parameters if you want to define the date range of paid invoices
        NULL::DATE AS start_date,
        NULL::DATE AS end_date,
        --'2000-01-01' :: DATE AS start_date, -- since there is no paymentDate now using approvalDate
        --'2021-01-15' :: DATE AS end_date, -- since there is no paymentDate now using approvalDate
        -- filters on invoice line level
        ''::VARCHAR AS invoice_line_status, -- Enter your invoice line status eg. 'Paid', 'Approved', 'Open' etc.
        -- filters on purchase order line level
        ''::VARCHAR AS po_line_order_format, -- Enter your po line format eg. 'Electronic Resource', 'Physical Resource', 'P/E Mix' etc.
        -- filters on instance level
        ''::VARCHAR AS instance_subject, -- Enter your  eg.  etc.
        ''::VARCHAR AS mode_of_issuance_name, -- Enter your mode_of_issuance_name eg.  etc.
        'computer -- online resource'::VARCHAR AS format_name, -- Enter your format_name eg. 'computer -- online resource'  etc.
        ''::VARCHAR AS library_name -- Enter your library_location_name eg.  etc.
),
     instance_detail AS (
         SELECT
             inst.instance_id AS "instance_id",
             inst.mode_of_issuance_name AS "instance_mode_of_issuance_name",
             inst_formats.format_name AS "instance_format_name",
             inst_subjects.subject AS "instance_subject",
             loc.library_name AS "instance_library_name"
         FROM
             folio_reporting.instance_ext AS inst
                 LEFT JOIN folio_reporting.instance_formats AS inst_formats ON inst.instance_id = inst_formats.instance_id
                 LEFT JOIN folio_reporting.instance_subjects AS inst_subjects ON inst.instance_id = inst_subjects.instance_id
                 LEFT JOIN folio_reporting.holdings_ext AS hld ON inst.instance_id = hld.instance_id
                 LEFT JOIN folio_reporting.locations_libraries AS loc ON hld.permanent_location_id = loc.location_id
     ),
-- bringing in no of subjects per instance for further calculations
     instance_subs AS (
         SELECT
             subs.instance_id AS "instance_id",
             count(DISTINCT subs.subject)::int AS "no_instance_subjects"
         FROM
             folio_reporting.instance_subjects AS subs
         GROUP BY
             subs.instance_id
     ),
-- bringing in no of formats per instance for further calculations
     instance_formats AS (
         SELECT
             forms.instance_id AS "instance_id",
             count(DISTINCT forms.format_name)::int AS "no_instance_formats"
         FROM
             folio_reporting.instance_formats AS forms
         GROUP BY
             forms.instance_id
     ),
     invoice_detail AS (
         SELECT
             inv.id AS "invoice_id",
             inv.approval_date AS "invoice_approval_date"
         FROM
             invoice_invoices AS inv
     )
SELECT
    invl.po_line_id,
    invl.id AS "invl_id",
    invl.invoice_line_status AS "invl_status",
    pol.payment_status AS "po_line_payment_status",
    pol.is_package AS "po_line_is_package",
    inv.invoice_approval_date AS "invoice_approval_date",
    pol.order_format AS "po_line_order_format",
    pol_phys_type.pol_mat_type_name AS "po_line_phys_mat_type",
    pol_er_type.pol_er_mat_type_name AS "po_line_er_mat_type",
    inst.instance_mode_of_issuance_name,
    invl_adjustments.adjustment_description AS "invl_adjustment_description",
    invl_adjustments.adjustment_prorate AS "invl_adjustment_prorate",
    invl_adjustments.adjustment_relationtototal AS "invl_adjustment_relationtototal",
    invl_adjustments.adjustment_value AS "invl_adjustment_value",
    cast(invl.sub_total AS money) AS "invl_sub_total",
    cast(invl.total AS money) AS "invl_total", -- this are costs by invoice_line
    inv_adj.inv_adj_prorate,
    inv_adj.inv_adj_relationtototal,
    cast(inv_adj.inv_adj_total AS money), -- this are adjustments on invoice level
    cast(inv_adj.inv_adj_total + invl.total AS money) AS invl_total, -- this are costs by invoice_line including adjustments on invoice level
    inst.instance_format_name,
    CASE WHEN instform.no_instance_formats = 0 THEN
             NULL
         ELSE
             cast((invl.total + coalesce(inv_adj.inv_adj_total, 0)) / instform.no_instance_formats AS money)
        END AS "total_by_format", -- this are costs by invoice_line prorated to the number of given formats including adjustments on invoice level
    inst.instance_subject,
    CASE WHEN instsub.no_instance_subjects = 0 THEN
             NULL
         ELSE
             cast((invl.total + coalesce(inv_adj.inv_adj_total, 0)) / instsub.no_instance_subjects AS money)
        END AS "total_by_subject" -- this are costs by invoice_line prorated to the number of given subjects including adjustments on invoice level
FROM
    invoice_lines AS invl
        LEFT JOIN invoice_detail AS inv ON invl.invoice_id = inv.invoice_id
        LEFT JOIN folio_reporting.invoice_adjustments_ext AS inv_adj ON invl.invoice_id = inv_adj.invoice_id
        LEFT JOIN po_lines AS pol ON invl.po_line_id = pol.id
        LEFT JOIN instance_detail AS inst ON pol.instance_id = inst.instance_id
        LEFT JOIN folio_reporting.po_lines_phys_mat_type AS pol_phys_type ON pol.instance_id = pol_phys_type.pol_id
        LEFT JOIN folio_reporting.po_lines_er_mat_type AS pol_er_type ON pol.instance_id = pol_er_type.pol_id
        LEFT JOIN folio_reporting.invoice_lines_adjustments AS invl_adjustments ON invl.id = invl_adjustments.invoice_line_id
        LEFT JOIN instance_subs AS instsub ON instsub.instance_id = inst.instance_id
        LEFT JOIN instance_formats AS instform ON instform.instance_id = inst.instance_id
WHERE
    ((inv.invoice_approval_date >= (SELECT start_date FROM parameters) OR
		inv.invoice_approval_date<= (SELECT end_date FROM parameters))			
		OR 
		(((SELECT start_date FROM parameters) IS NULL) 
			OR ((SELECT end_date FROM parameters) IS NULL)))
	AND 	
	((invl.invoice_line_status = (SELECT invoice_line_status FROM parameters)) OR 
		((SELECT invoice_line_status FROM parameters) = ''))
	AND 	
	((pol.order_format = (SELECT po_line_order_format FROM parameters)) OR 
		((SELECT po_line_order_format FROM parameters) = ''))	
	AND 	
	((inst.instance_format_name = (SELECT format_name FROM parameters)) OR 
		((SELECT format_name FROM parameters) = ''))		
	AND 	
	((inst.instance_subject = (SELECT instance_subject FROM parameters)) OR 
		((SELECT instance_subject FROM parameters) = ''))	
	AND 	
	((inst.instance_mode_of_issuance_name = (SELECT mode_of_issuance_name FROM parameters)) OR 
		((SELECT mode_of_issuance_name FROM parameters) = ''))	
	AND 	
	((inst.instance_library_name = (SELECT library_name FROM parameters)) OR 
		((SELECT library_name FROM parameters) = ''))	
		
GROUP BY 
	invl.po_line_id,
	invl.id,
	invl.invoice_line_status,
	pol.payment_status,
	pol.is_package,
	inv.invoice_approval_date,
	pol.order_format,
	pol_phys_type.pol_mat_type_name,
	pol_er_type.pol_er_mat_type_name,
	inst.instance_mode_of_issuance_name,
	invl_adjustments.adjustment_description,
	invl_adjustments.adjustment_prorate,
	invl_adjustments.adjustment_relationtototal,
	invl_adjustments.adjustment_value,
	invl.sub_total,
	invl.total,
	inv_adj.inv_adj_prorate,
	inv_adj.inv_adj_relationtototal,
	inv_adj.inv_adj_total,
	inst.instance_format_name, 
	instform.no_instance_formats, 
	inst.instance_subject, 
	instsub.no_instance_subjects
	;
