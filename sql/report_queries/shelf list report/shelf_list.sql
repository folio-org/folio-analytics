/*
Fields Included:
	Instance_ext Folio Reporting table:
		Instance id
		Instance hrid
		Suppressed from discovery
		Title
		Name of Contributor
		Contributor is primary or not
	Instance_identifiers Folio Reporting table:
		Name of the identifier type
		Value of the identifier
	Holdings ext Folio Reporting table:
		holdings id
		holdings hrid
	Item ext Folio Reporting table:
		Item id
		Item hrid
		Item barcode
		Item chronology
		Item enumeration
		Item effective call number
		Item material type name
		Item Permanent location
		Item Temporary location
	Loans_items Folio Reporting table:
		Item status
		loan due date
		loan return date
	Loans_renewal_count Folio Reporting table:
		Number of loans
	Locations_libraries Folio Reporting table:
		Library name
		Campus name
		Institution name
*/
SELECT
	frin.instance_id,
	frin.instance_hrid,
	frin.discovery_suppress,
	frin.title,
	fric.contributor_name,
	fric.contributor_primary,
	friden.identifier_type_name,
	friden.identifier,
	--frhe.holdings_id,
	--frhe.holdings_hrid,
	fritem.item_id,
	fritem.item_hrid,
	fritem.barcode,
	fritem.chronology,
	fritem.enumeration,
	fritem.effective_call_number,
	fritem.material_type_name,
	fritem.permanent_location_name,
	fritem.temporary_location_name,
	frli.item_status,
	frli.loan_due_date,
	frli.loan_return_date,
	frlrc.num_loans,
	frll.library_name,
	frll.campus_name,
	frll.institution_name
FROM 
	folio_reporting.item_ext fritem
	LEFT JOIN folio_reporting.holdings_ext AS frhe ON fritem.holdings_record_id = frhe.holdings_id
	LEFT JOIN folio_reporting.instance_ext AS frin ON frhe.instance_id = frin.instance_id 
	LEFT JOIN folio_reporting.instance_contributors AS fric ON frin.instance_id = fric.instance_id
	LEFT JOIN folio_reporting.instance_identifiers AS friden ON frin.instance_id = friden.instance_id 
	LEFT JOIN folio_reporting.loans_items AS frli ON fritem.item_id = frli.item_id 
	LEFT JOIN folio_reporting.loans_renewal_count AS frlrc ON fritem.item_id = frlrc.item_id 
	LEFT JOIN folio_reporting.locations_libraries AS frll ON fritem.permanent_location_id = frll.location_id 
/*Insert filters here
WHERE
	--Insert the name of the institution. Including the null will provide the empty values.
	((frll.institution_name = 'Københavns Universitet') OR (frll.institution_name IS NULL))
AND
	--Insert the name of the campus. Including the null will provide all empty values.
	((frll.campus_name = 'Online') OR (frll.campus_name IS NULL))
AND
	--Insert the name of the library. Including the null will provide all empty values.
	((frll.library_name = 'Online') OR (frll.library_name IS NULL))
AND
	--Insert filter for instance suppressed from discovery. Including the null will provide all empty values.
	((frin.discovery_suppress IS TRUE) or (frin.discovery_suppress IS NULL))
*/	
	;