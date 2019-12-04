/*FIELDS INCLUDED IN SAMPLE:
Items table	
	Item ID
	Item permanent location (filter)
	Item temporary location (filter)
	Item status (filter)
	Date range (filter)
	Item Transit destination service point name (filter)
	Item barcode
	Item material type ID
	Item call number
	Item holdings record ID
	Item volume number
	Item enumeration
	Item chronology
	Item copy number
	Item note
Loans table
	Loan ID
	Loan renewal count
	Loan item ID
	Loan item effective location at checkout
Material types table
	Material type ID
	Material type name
Holdings table
	Holdings ID
	Holdings Item permanent location (filter)
	Holdings Item temporary location (filter)
	Holdings shelving title
	Holdings instance ID
Locations table
	Location ID
	Location name
Instances table
	Instance ID
	Instance date of publication
	Instance catalogued date
Service points table
	Service points ID
	Service points name
Temp loans table
	temp loans id
	temp loans location (effective location) (filter)

FILTERS: item status type, item status date, location

AGGREGATION: number of loans for each item, loan renewal counts, sum of these two aggregations

Note: We are using item status 'In transit' to indicate that an item is missing.
You can set the date range to specify that it is older, closed loans with "In transit"
status that constitute missing items.
*/

/* Change the lines below to adjust the date, item status, and location filters */
WITH parameters AS (
    SELECT
        '2000-01-01' :: DATE AS start_date,
        '2020-01-01' :: DATE AS end_date,
        'In transit' :: VARCHAR AS item_status_filter,
        /*choose only ONE of the following location parameters*/
		--'Main Library' :: VARCHAR AS items_permanent_location_filter
		--'Annex' :: VARCHAR AS items_temporary_location_filter
		'Main Library' :: VARCHAR AS holdings_permanent_location_filter -- has results
		--'Main Library' :: VARCHAR AS holdings_temporary_location_filter
		--'Main Library' :: VARCHAR AS effective_location_filter -- has results
		--'Circ Desk 1' :: VARCHAR AS in_transit_destination_service_point_filter -- has results
        )
SELECT
	(SELECT start_date :: VARCHAR FROM parameters) ||
        ' to ' :: VARCHAR ||
        (SELECT end_date :: VARCHAR FROM parameters) AS date_range,
    /*
     * I'm wondering if there is a flaw in the logic with this query. We are filtering
     * to find items who status changed to something in a particular time period.
     * Since the item status is basically the latest status of the item, that makes sense.
     * Then we join that item to all of its loans to get the effective location of
     * the item when checked out, but that will create a row for every loan for that item, right?
     * It won't automatically limit it to the effective location of the loan that changed the 
     * item's status, so I think that still needs work.
     */
	hploc.name AS holdings_permanent_location_name,
	htloc.name AS holdings_temporary_location_name,
	h.shelving_title,
	iploc.name AS items_permanent_location_name,
	itloc.name AS items_temporary_location_name,
	i.barcode,
	i.item_level_call_number,
	--i.volume,
	json_extract_path_text(i.data, 'volume') AS volume,
	i.enumeration,
	i.chronology,
	json_extract_path_text(i.data, 'status', 'name') AS item_status_name,
	json_extract_path_text(i.data, 'status', 'date') AS item_status_date,
	json_extract_path_text(i.data, 'notes', 'description') AS item_notes,
	'{ "copyNumbers": ' :: varchar || 
        COALESCE(json_extract_path_text(i.data, 'copyNumbers'), '[]' :: varchar) ||
		'}' :: varchar AS copy_numbers,
    cosp.name AS checkout_service_point_name,
    cisp.name AS checkin_service_point_name,
    ins.cataloged_date,
    json_extract_path_text(ins.data, 'publication', 'dateOfPulication') AS instance_publication_date,
    m.name AS material_type_name,
    itsp.name AS in_transit_destination_service_point_name,
    tl.temp_location AS effective_location_name,
    l2.num_loans + l2.num_renewals AS num_loans_and_renewals
FROM (
    SELECT
        id,
        holdings_record_id,
        permanent_location_id,
        temporary_location_id,
        in_transit_destination_service_point_id,
        barcode,
        material_type_id,
        item_level_call_number,
        --volume,
        enumeration,
        chronology,
        data
	FROM items	
    WHERE
	    json_extract_path_text(data, 'status', 'name') = (SELECT item_status_filter FROM parameters)
	--skipping item status date filter for now - no dates in test data    
    --AND json_extract_path_text(data, 'status', 'date')::DATE >= (SELECT start_date FROM parameters)
    --AND json_extract_path_text(data, 'status', 'date')::DATE <  (SELECT end_date FROM parameters)    
) AS i
LEFT JOIN holdings AS h
	ON i.holdings_record_id = h.id
/* This should be pulling the latest loan for each item. Worth testing more. */
LEFT JOIN (
	SELECT 
	    DISTINCT ON (return_date)
	    id,
	    item_id,
	    -- add effective location when available
	    checkout_service_point_id,
	    checkin_service_point_id
    FROM loans
    ORDER BY return_date DESC
) AS l
	ON i.id = l.item_id 
LEFT JOIN instances AS ins
	ON h.instance_id = ins.id
LEFT JOIN material_types AS m
	ON i.material_type_id = m.id
LEFT JOIN service_points AS cosp 
	ON l.checkout_service_point_id=cosp.id 
LEFT JOIN service_points AS cisp 
	ON l.checkin_service_point_id=cisp.id 
LEFT JOIN service_points AS itsp 
	ON i.in_transit_destination_service_point_id=itsp.id 
LEFT JOIN locations AS hploc
	ON h.permanent_location_id = hploc.id
--LEFT JOIN locations AS htloc
--	ON h.temporary_location_id = htloc.id
LEFT JOIN locations AS htloc
	ON json_extract_path_text(h.data, 'temporary_location_id') = htloc.id
LEFT JOIN locations AS iploc
	ON i.permanent_location_id = iploc.id
LEFT JOIN locations AS itloc
	ON i.temporary_location_id = itloc.id
-- temp solution for effective location, until it gets added to loans	
LEFT JOIN temp_loans AS tl
    ON l.id = tl.id
LEFT JOIN (
    SELECT
    	item_id,
        COUNT(id) AS num_loans,
        SUM(renewal_count) AS num_renewals
    FROM loans
    GROUP BY item_id
) AS l2
	ON i.id = l2.item_id
WHERE 
    /*choose only ONE of the statements below, to match with choice of location filter*/
    --iploc.name = (SELECT items_permanent_location_filter FROM parameters)
    --itloc.name = (SELECT items_temporary_location_filter FROM parameters)
    hploc.name = (SELECT holdings_permanent_location_filter FROM parameters)
    --htloc.name = (SELECT holdings_temporary_location_filter FROM parameters)
    --tl.temp_location = (SELECT effective_location_filter FROM parameters)
    --itsp.name = (SELECT in_transit_destination_service_point_filter FROM parameters)
 ;

     	
   
