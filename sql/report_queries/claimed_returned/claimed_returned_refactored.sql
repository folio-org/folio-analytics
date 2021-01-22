--Claimed returned refactored using derived tables
--FILTERS: loan item status, loan date range, location name 

WITH parameters AS (
    SELECT
        /* Search loans with this status */
    	--change status to Claimed returned, which does not currently exist in the test data.
        'Checked out' :: VARCHAR AS item_status_filter, --Claimed returned
        /* Choose a start and end date for the loans period */
        '2000-01-01' :: DATE AS start_date,
        '2022-01-01' :: DATE AS end_date,
        /* Fill in a location name, OR leave blank for all locations */
        '' :: VARCHAR AS current_item_permanent_location_filter, --Online, Annex, Main Library
        '' :: VARCHAR AS current_item_temporary_location_filter, --Online, Annex, Main Library
        'Main Library' :: VARCHAR AS current_item_effective_location_filter,--Online, Annex, Main Library
        '' :: VARCHAR AS current_item_permanent_location_institution_filter, -- 'Københavns Universitet','Montoya College'
        '' :: VARCHAR AS current_item_permanent_location_campus_filter, -- 'Main Campus','City Campus','Online'
        '' :: VARCHAR AS current_item_permanent_location_library_filter -- 'Datalogisk Institut','Adelaide Library'
   ),
   notes as (
   		SELECT item_id,
   		STRING_AGG (DISTINCT note, '|'::text) AS item_notes
   		FROM folio_reporting.item_notes
   		GROUP BY item_id
   ),
   publication_d as (
   		SELECT instance_id,
   		STRING_AGG (DISTINCT date_of_publication, '|'::text) AS dates_of_publication
   		FROM folio_reporting.instance_publication
   		GROUP BY instance_id
   )
SELECT 
	(SELECT start_date :: VARCHAR FROM parameters) ||
        ' to ' :: VARCHAR ||
        (SELECT end_date :: VARCHAR FROM parameters) AS date_range,
    li.loan_id,
    li.item_id,
    li.loan_date,
    li.loan_due_date,
    li.loan_return_date,
    JSON_EXTRACT_PATH_TEXT(l.data, 'claimedReturnedDate') :: DATE AS claimed_returned_date,
    li.item_status,
    nn.item_notes,
    li.item_effective_location_name_at_check_out,
    li.loan_policy_name,
    li.permanent_loan_type_name,
    li.current_item_temporary_location_name,
    li.current_item_effective_location_name,
    li.current_item_permanent_location_name,
    li.current_item_permanent_location_library_name,
    li.current_item_permanent_location_campus_name,
    li.current_item_permanent_location_institution_name,
    li.barcode,
    li.material_type_name,
    li.chronology,
    li.copy_number,
    li.enumeration,
    li.item_level_call_number,
    li.number_of_pieces,
    ie.volume,
    ie.call_number,
  --he.holdings_id,
  --he.instance_id,
    he.permanent_location_name,
    he.temporary_location_name,
    he.shelving_title,
    ii.cataloged_date, 
	pd.dates_of_publication,
    lrc.num_loans,
    lrc.num_renewals,
  --li.user_id,
    li.patron_group_name,
--  li.proxy_user_id,
    JSON_EXTRACT_PATH_TEXT(uu.data, 'personal', 'firstName') :: VARCHAR AS first_name,
    JSON_EXTRACT_PATH_TEXT(uu.data, 'personal', 'middleName') :: VARCHAR AS middle_name,
    JSON_EXTRACT_PATH_TEXT(uu.data, 'personal', 'lastName') :: VARCHAR AS last_name,
    JSON_EXTRACT_PATH_TEXT(uu.data, 'personal', 'email' :: VARCHAR) AS email
FROM
    folio_reporting.loans_items AS li
LEFT JOIN public.user_users AS uu
	ON li.user_id=uu.id
LEFT JOIN public.circulation_loans AS l
	ON li.loan_id=l.id
LEFT JOIN folio_reporting.item_ext AS ie
	ON li.item_id=ie.item_id
LEFT JOIN notes AS nn
	ON li.item_id=nn.item_id
LEFT JOIN folio_reporting.holdings_ext AS he
	ON ie.holdings_record_id = he.holdings_id
LEFT JOIN public.inventory_instances as ii
	ON he.instance_id=ii.id
LEFT JOIN publication_d as pd
	ON he.instance_id=pd.instance_id
LEFT JOIN folio_reporting.instance_publication as ip
	ON he.instance_id=ip.instance_id
LEFT JOIN folio_reporting.loans_renewal_count AS lrc
	ON li.item_id=lrc.item_id
WHERE li.current_item_permanent_location_name = (SELECT current_item_permanent_location_filter FROM parameters)
		OR  (li.current_item_temporary_location_name = (SELECT current_item_temporary_location_filter FROM parameters))
		OR  (li.current_item_effective_location_name = (SELECT current_item_effective_location_filter FROM parameters))
		OR	(li.current_item_permanent_location_library_name = (SELECT current_item_permanent_location_library_filter FROM parameters))
		OR	(li.current_item_permanent_location_institution_name = (SELECT current_item_permanent_location_institution_filter FROM parameters))
		OR	(li.current_item_permanent_location_campus_name = (SELECT current_item_permanent_location_campus_filter FROM parameters))
	AND	li.item_status = (SELECT item_status_filter FROM parameters)  	
	AND li.loan_date >= (SELECT start_date FROM parameters)
	AND li.loan_date < (SELECT end_date FROM parameters)
	;
    
	