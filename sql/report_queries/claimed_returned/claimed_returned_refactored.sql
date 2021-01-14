--Claimed returned refactored using derived tables

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
        'Main Library' :: VARCHAR AS current_item_effective_location_filter --Online, Annex, Main Library
   )
SELECT 
	(SELECT start_date :: VARCHAR FROM parameters) ||
        ' to ' :: VARCHAR ||
        (SELECT end_date :: VARCHAR FROM parameters) AS date_range,
    li.loan_id,
    li.item_id,
    li.loan_date,
    li.loan_due_date,
    li.item_status,
  --li.claimed_returned_date (not yet in the loans or the loans_items tables)  
    li.item_effective_location_name_at_check_out,
    li.loan_return_date,
    li.loan_policy_name,
    li.user_id,
    li.patron_group_name,
    li.proxy_user_id,
    li.current_item_temporary_location_name,
    li.current_item_effective_location_name,
    li.current_item_permanent_location_name,
    li.barcode,
    li.material_type_name,
    li.chronology,
    li.copy_number,
    li.enumeration,
    li.item_level_call_number,
    li.number_of_pieces,
    li.permanent_loan_type_name,
    --li.item_notes (this needs to be added to the derived table)
    JSON_EXTRACT_PATH_TEXT(uu.data, 'personal', 'firstName') :: VARCHAR AS first_name,
    JSON_EXTRACT_PATH_TEXT(uu.data, 'personal', 'middleName') :: VARCHAR AS middle_name,
    JSON_EXTRACT_PATH_TEXT(uu.data, 'personal', 'lastName') :: VARCHAR AS last_name,
    JSON_EXTRACT_PATH_TEXT(uu.data, 'personal', 'email' :: VARCHAR) AS email,
    ie.volume,
    ie.call_number,
    he.holdings_id,
    he.instance_id,
    he.permanent_location_name,
    he.temporary_location_name,
    he.shelving_title,
    ii.cataloged_date, 
 -- MYSTERY: If the date of publication (line below) is included, we get only one row of data.    
 -- JSON_EXTRACT_PATH_TEXT(JSON_ARRAY_ELEMENTS(JSON_EXTRACT_PATH(ii.data, 'publication')),'dateOfPublication') :: VARCHAR AS date_of_publication,
    JSON_EXTRACT_PATH_TEXT(uu.data, 'personal', 'firstName') :: VARCHAR AS first_name,
    JSON_EXTRACT_PATH_TEXT(uu.data, 'personal', 'middleName') :: VARCHAR AS middle_name,
    JSON_EXTRACT_PATH_TEXT(uu.data, 'personal', 'lastName') :: VARCHAR AS last_name,
    JSON_EXTRACT_PATH_TEXT(uu.data, 'personal', 'email' :: VARCHAR) AS email,
    lrc.num_loans,
    lrc.num_renewals
FROM
    folio_reporting.loans_items AS li
LEFT JOIN public.user_users AS uu
	ON li.user_id=uu.id
LEFT JOIN folio_reporting.item_ext AS ie
	ON li.item_id=ie.item_id
LEFT JOIN folio_reporting.holdings_ext AS he
	ON ie.holdings_record_id = he.holdings_id
LEFT JOIN public.inventory_instances as ii
	ON he.instance_id=ii.id
LEFT JOIN folio_reporting.loans_renewal_count AS lrc
	ON li.item_id=lrc.item_id
WHERE li.current_item_permanent_location_name = (SELECT current_item_permanent_location_filter FROM parameters)
		OR  (li.current_item_temporary_location_name = (SELECT current_item_temporary_location_filter FROM parameters))
		OR  (li.current_item_effective_location_name = (SELECT current_item_effective_location_filter FROM parameters))
	AND	li.item_status = (SELECT item_status_filter FROM parameters)  	
	AND li.loan_date >= (SELECT start_date FROM parameters)
	AND li.loan_date < (SELECT end_date FROM parameters)
	;
    
	
