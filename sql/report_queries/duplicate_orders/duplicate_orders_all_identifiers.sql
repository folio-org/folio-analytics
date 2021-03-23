-- duplicate orders where any identifier matches another identifier. Will not match valid isbn to invalid isbn or valid oclc number to cancelled oclc number.

WITH parameters AS (
SELECT
	'2021-02-01'::DATE AS start_date,
	'2021-02-16'::DATE AS end_date
)
SELECT 
 	poi.po_number AS po_number,
	poi.vendor_code AS vendor_code,
	poi.created_date AS po_created_date,
	poi.created_by AS po_created_by,
	poi.created_location AS po_created_location,
	poi.status_approved AS status_approved,
	poi.rush AS rush,
	poi.requester AS requester,
	poi.pol_instance_id AS pol_instance_id,
	ii1.instance_hrid AS po_instance_hrid,
	poi.title AS po_instance_title,
	poi.publication_date AS po_publication_date,
	poi.publisher AS po_publisher, 
	ii2.instance_hrid AS duplicate_instance_hrid,
	ii2.identifier_type_name AS duplicate_identifier_type,
	ii2.identifier AS duplicate_identifier
FROM
	folio_reporting.po_instance AS poi
LEFT JOIN 
	folio_reporting.instance_identifiers AS ii1 ON poi.pol_instance_id = ii1.instance_id 
LEFT JOIN
	folio_reporting.instance_identifiers AS ii2 ON ii1.identifier = ii2.identifier
WHERE 
	ii1.instance_id != ii2.instance_id	
	AND ii1.identifier_type_name = ii2.identifier_type_name
	AND poi.created_date::DATE >= (SELECT start_date FROM parameters)
	AND poi.created_date::DATE < (SELECT end_date FROM parameters);
