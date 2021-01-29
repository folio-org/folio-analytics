/*
Set Filters at the end of the query to modify or comment out. 
	Item Discovery Suppress - Does show in results and is set to False or Null
	Holdings Discovery Suppress - Does not show in results and is set to False or Null
	Instance Discovery Suppress - Does not show in results and is set to False or Null
	Instance Identifier Type - Does show in results and is set to match on string 'OCLC'. 
Fields Included:
	Instance_ext Folio Reporting table:
		Instance id
		Instance hrid
		Suppressed from discovery - filter only not in results 
		Title
		Name of Contributor
		Contributor is primary or not
	Instance_identifiers Folio Reporting table:
		Name of the identifier type
		Value of the identifier
	Holdings ext Folio Reporting table:
		holdings id - not in results
		holdings hrid - not in results
		holdings discovery suppress - filter only not in results
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
		Item discovery suppress
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
WITH parameters AS (
	SELECT
	 ---- Fill out one, leave others blank to filter location name or code ----
        '' ::VARCHAR AS institution_filter, -- 'KÃ¸benhavns Universitet','Montoya College'
        '' ::VARCHAR AS campus_filter, -- 'Main Campus','City Campus','Online'
        '' ::VARCHAR AS library_filter, -- 'Datalogisk Institut','Adelaide Library'
        'Main Library' ::VARCHAR AS location_filter -- 'Main Library','Annex','Online'
),
location_filtering AS (
	SELECT
		ii.id AS i_id,
		loc.location_id,
		loc.location_name,
		loc.campus_id,
		loc.campus_name,
		loc.library_id,
		loc.library_name,
		loc.institution_id,
		loc.institution_name
	FROM 
		inventory_items AS ii
		LEFT JOIN folio_reporting.locations_libraries AS loc ON ii.effective_location_id = loc.location_id 
),
loan_info AS (
	SELECT 
		ie.item_id,
		li.item_status,
		li.loan_due_date AS item_loan_due_date,
		li.loan_return_date AS item_loan_return_date,
		lrc.num_loans AS item_num_loans
	FROM 
		folio_reporting.item_ext AS ie
		LEFT JOIN folio_reporting.loans_items AS li ON ie.item_id = li.item_id
		LEFT JOIN folio_reporting.loans_renewal_count AS lrc ON ie.item_id = lrc.item_id 
),
inst_contributors AS (
	SELECT 
		DISTINCT ie.item_id,
		ie.item_hrid,
		he2.holdings_id,
		ie3.instance_id,
		ic2.contributor_name,
		ic2.contributor_primary 
	FROM 
		folio_reporting.item_ext AS ie 
		LEFT JOIN folio_reporting.holdings_ext AS he2 ON ie.holdings_record_id = he2.holdings_id 
		LEFT JOIN folio_reporting.instance_ext AS ie3 ON he2.instance_id = ie3.instance_id 
		LEFT JOIN folio_reporting.instance_contributors AS ic2 ON ie3.instance_id = ic2.instance_id 
)
SELECT
	i.item_id,
	i.item_hrid,
	i.barcode,
	i.chronology,
	i.enumeration,
	i.effective_call_number,
	i.material_type_name,
	i.status_name AS status,
	loan_info.item_status AS loan_item_status,
	i.permanent_location_name,
	i.temporary_location_name,
	i.discovery_suppress as item_suppressed,
	loan_info.item_loan_due_date,
	loan_info.item_loan_return_date,
	loan_info.item_num_loans,
	loc_fil.location_name,
	loc_fil.campus_name,
	loc_fil.library_name,
	loc_fil.institution_name,
	ie2.instance_hrid,
	ie2.title,
	contrib.contributor_name,
	contrib.contributor_primary,
	ii2.identifier_type_name 
FROM 
	folio_reporting.item_ext AS i
	LEFT JOIN loan_info ON i.item_id = loan_info.item_id
	LEFT JOIN location_filtering AS loc_fil ON i.item_id = loc_fil.i_id
	LEFT JOIN inst_contributors AS contrib ON i.item_id = contrib.item_id
	LEFT JOIN folio_reporting.holdings_ext AS he ON i.holdings_record_id = he.holdings_id 
	LEFT JOIN folio_reporting.instance_ext AS ie2 ON he.instance_id = ie2.instance_id
	LEFT JOIN folio_reporting.instance_identifiers AS ii2 ON ie2.instance_id = ii2.instance_id
--FILTERS: Item, holdings, and Instance records are not marked as suppress from discovery and Identifier is OCLC
WHERE 
	((i.discovery_suppress IS FALSE) OR (i.discovery_suppress IS NULL))
AND 
	((he.discovery_suppress IS FALSE) OR (he.discovery_suppress IS NULL))
AND 
	((ie2.discovery_suppress IS FALSE) OR (ie2.discovery_suppress IS NULL))
AND 
	ii2.identifier_type_name IN('OCLC')
AND 
	loc_fil.institution_name = (SELECT institution_filter FROM parameters)
OR 
	loc_fil.campus_name = (SELECT campus_filter FROM parameters)
OR 
	loc_fil.library_name = (SELECT library_filter FROM parameters)
OR
	loc_fil.location_name = (SELECT location_filter FROM parameters)
;
