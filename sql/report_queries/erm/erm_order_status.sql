/** Documentation of ERM ORDER STATUS QUERY

PURPOSE
This report cluster covers reports on the status of purchase orders. Check for currently open orders, as well as Pending "Not Yet Published" titles and were updated in the last 30 days.

MAIN TABLES
	invoice_lines
	srs_marctab
	organization_organizations
	po_lines
	po_purchase_orders
	folio_reporting.instance_contributors
	folio_reporting.instance_ext
	folio_reporting.instance_identifiers
	folio_reporting.instance_publication
	folio_reporting.po_lines_cost

FILTERS FOR USERS TO ADJUST
	days back to current date on 'date updated'

*/

WITH parameters AS (
    SELECT
           current_date - integer '30' AS days_prior_to_current_date -- get all orders created XX days from today
    ),
    instance_authors AS (
SELECT
    inst.instance_id,
    string_agg(ic.contributor_name, ', ') AS authors
FROM
    folio_reporting.instance_ext  AS inst
    LEFT JOIN folio_reporting.instance_contributors AS ic ON inst.instance_id = ic.instance_id
GROUP BY
    inst.instance_id
    ),
    instance_ids AS (
SELECT
    inst.instance_id,
    string_agg(ii.identifier, ', ') AS identifier
FROM
    folio_reporting.instance_ext  AS inst
    LEFT JOIN folio_reporting.instance_identifiers AS ii ON inst.instance_id = ii.instance_id WHERE ii.identifier_type_name in ('ISBN', 'Invalid ISBN')
GROUP BY
    inst.instance_id
    )

-- MAIN QUERY
SELECT
    po.id AS po_id,
    po.po_number,
    json_extract_path_text(po.data, 'metadata', 'createdDate')::date AS po_created_date,
    vendor.code AS vendor_code,
    po.workflow_status AS po_status,
    po.approved AS po_approved,
    po.order_type AS po_order_type,
    pol.po_line_number,
    pol.instance_id AS pol_instance_id,
    inst.title,
    inst_ids.identifier AS ISBNs,
    inst_auth.authors,
    inst.discovery_suppress,
    pub.publisher AS pub_publisher,
    pol.receipt_status AS pol_receipt_status,
    pol.requester AS pol_requester,
    plc.po_lines_quant_phys AS no_physical,
    plc.po_lines_quant_elec AS no_electronical,
    plc.po_lines_estimated_price AS pol_estimated_price,
    po.approved_by_id,
    invl.invoice_id,
    marc.field,
    string_agg('$'::varchar || marc.sf || marc.content, '') AS series
FROM
    po_purchase_orders AS po
        LEFT JOIN organization_organizations AS vendor ON po.vendor = vendor.id
        LEFT JOIN po_lines AS pol ON pol.purchase_order_id = po.id
        LEFT JOIN folio_reporting.instance_ext AS inst ON pol.instance_id = inst.instance_id
        LEFT JOIN folio_reporting.instance_publication AS pub ON pol.instance_id = pub.instance_id
        LEFT JOIN instance_authors AS inst_auth ON inst_auth.instance_id = pol.instance_id
        LEFT JOIN instance_ids AS inst_ids ON inst_ids.instance_id = pol.instance_id
        LEFT JOIN folio_reporting.po_lines_cost AS plc ON pol.id = plc.pol_id
        LEFT JOIN invoice_lines AS invl ON pol.id = invl.po_line_id
        LEFT JOIN srs_marctab AS marc ON inst.instance_id = marc.instance_id

-- filters for date updated
WHERE
    json_extract_path_text(po.data, 'metadata', 'updatedDate')::date >= (SELECT days_prior_to_current_date FROM parameters)
    AND
	marc.field IN ('490','830')
GROUP BY 
	po.id,
	vendor.code,
	pol.po_line_number,
	pol.instance_id,
	inst.title,
	inst_ids.identifier,
	inst_auth.authors,
	inst.discovery_suppress,
	pub.publisher,
	pol.receipt_status,
	pol.requester,
	plc.po_lines_quant_phys,
    plc.po_lines_quant_elec,
    plc.po_lines_estimated_price,
	invl.invoice_id,
	marc.field
;