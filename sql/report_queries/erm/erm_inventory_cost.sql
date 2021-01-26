WITH parameters AS (
    SELECT
    	-- filters on invoice level
    	-- Please comment/uncomment one pair the these parameters if you want to define the date range of paid invoices  
       	NULL :: DATE AS start_date,
        NULL :: DATE AS end_date,
        --'2000-01-01' :: DATE AS start_date, -- since there is no paymentDate now using approvalDate
   	 	--'2021-01-15' :: DATE AS end_date, -- since there is no paymentDate now using approvalDate
   	 	
        -- filters on invoice line level
		'' :: VARCHAR AS invoice_line_status,  -- Enter your invoice line status eg. 'Paid', 'Approved', 'Open' etc.
		
		-- filters on purchase order line level
		'' :: VARCHAR AS po_line_order_format,  -- Enter your po line format eg. 'Electronic Resource', 'Physical Resource', 'P/E Mix' etc.
		
        -- filters on instance level
        '' :: VARCHAR AS instance_subject, -- Enter your  eg.  etc.
        '' :: VARCHAR AS mode_of_issuance_name, -- Enter your mode_of_issuance_name eg.  etc.
        '' :: VARCHAR AS format_name, -- Enter your format_name eg.  etc.
        '' :: VARCHAR AS library_name -- Enter your library_location_name eg.  etc.
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
	LEFT JOIN folio_reporting.instance_formats AS inst_formats
		ON inst.instance_id = inst_formats.instance_id
	LEFT JOIN folio_reporting.instance_subjects AS inst_subjects
		ON inst.instance_id = inst_subjects.instance_id
	LEFT JOIN folio_reporting.holdings_ext AS hld 
		ON inst.instance_id = hld.instance_id
    LEFT JOIN folio_reporting.locations_libraries AS loc 
        ON hld.permanent_location_id = loc.location_id
),

-- should this be in a derived table?
instance_subs AS (
SELECT 
	subs.instance_id AS "instance_id",
	count (DISTINCT subs.subject) AS "no_instance_subjects"
FROM 
	folio_reporting.instance_subjects AS subs
GROUP BY
	subs.instance_id
),

instance_formats AS (
SELECT 
	forms.instance_id AS "instance_id",
	count (DISTINCT forms.format_name) AS "no_instance_formats"
FROM 
	folio_reporting.instance_formats AS forms
GROUP BY
	forms.instance_id
),

invoice_detail AS (
SELECT
	inv.id AS "invoice_id",
	inv.approval_date AS "invoice_approval_date"
FROM invoice_invoices AS inv
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
	invl_adjustments.adjustment_description  AS "invl_adjustment_description",
	invl_adjustments.adjustment_prorate AS "invl_adjustment_prorate",
	invl_adjustments.adjustment_relationtototal AS "invl_adjustment_relationtototal",
	invl_adjustments.adjustment_value AS "invl_adjustment_value",
	invl.sub_total AS "invl_sub_total",
	invl.total AS "invl_total",
	inst.instance_format_name, -- should be filter will duplicate invl
	ROUND (invl.total::decimal / instform.no_instance_formats::decimal, 2) AS "total_by_format", -- this are cost by invoice_line prorated to the number of given formats
	inst.instance_subject, -- should be filter will duplicate invl
	ROUND (invl.total::decimal / instsub.no_instance_subjects::decimal, 2) AS "total_by_subject" -- this are cost by invoice_line prorated to the number of given subjects

FROM invoice_lines AS invl
LEFT JOIN invoice_detail AS inv
	ON invl.invoice_id = inv.invoice_id
LEFT JOIN po_lines AS pol
	ON invl.po_line_id = pol.id
LEFT JOIN instance_detail AS inst
	ON pol.instance_id = inst.instance_id
LEFT JOIN folio_reporting.po_lines_phys_mat_type AS pol_phys_type
	ON pol.instance_id = pol_phys_type.pol_id
LEFT JOIN folio_reporting.po_lines_er_mat_type AS pol_er_type
	ON pol.instance_id = pol_er_type.pol_id	
LEFT JOIN folio_reporting.invoice_lines_adjustments AS invl_adjustments
	ON invl.id = invl_adjustments.invoice_line_id
LEFT JOIN instance_subs AS instsub
	ON instsub.instance_id = inst.instance_id
LEFT JOIN instance_formats AS instform
	ON instform.instance_id = inst.instance_id	

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
	inst.instance_format_name, -- should be filter will duplicate invl
	instform.no_instance_formats, 
	inst.instance_subject, -- should be filter will duplicate invl
	instsub.no_instance_subjects
	;
