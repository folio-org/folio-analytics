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
*/

/* Change the lines below to adjust the date, item status, and location filters */
WITH parameters AS (
    SELECT
        '2000-01-01' :: DATE AS start_date,
        '2020-01-01' :: DATE AS end_date,
        /*
        Is the item status filter supposed to determine if the item is missing?
        Is 'Available' correct here, or is that just because the test data is lacking?
        Maybe define the logic of the query in the comments somewhere.
        For example, "we consider an item missing if status is 'In transit' and
        status date is older than 5 days."
        
        If something like that is correct, might be nicer to just have the date parameter
        be a time period, like 5 days.
        */
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
     * NOTE: identifiers are not human readable, so normally I wouldn't expect them
     * to be in the actual query results, unless the report requester expects to need
     * to do some additional data joins later. I have commented them out.
     * Also, sometimes the same identifier has been included twice - for example,
     * item_id from loans, but also the id from items. If ids really are needed in the query,
     * just include one copy. I suggest the one where it is the primary id, like items.id.
     * I have removed duplicates, commented the remaining ids.
     * 
     * Please also be careful about capital letters. Many fields had been using 
     * "ID" instead of "id".
     * 
     * You weren't including names for all of the location fields, so someone would 
     * have to change the join field to get the correct name for the filter. I think it
     * might be nicer to have all of the names available, so they can just change the
     * parameter and the WHERE clause. To do that, I joined each location id field to 
     * a separate copy of the locations table. Same with service points.
     * 
     * I'm wondering if there is a flaw in the logic with this query. We are filtering
     * to find items who status changed to something in a particular time period.
     * Since the item status is basically the latest status of the item, that makes sense.
     * Then we join that item to all of its loans to get the effective location of
     * the item when checked out, but that will create a row for every loan for that item, right?
     * It won't automatically limit it to the effective location of the loan that changed the 
     * item's status, so I think that still needs work.
     */
	--h.id AS holdings_id,
	--hploc.id AS holdings_permanent_location_id,
	hploc.name AS holdings_permanent_location_name,
	--htloc.id AS holdings_temporary_location_id,
	htloc.name AS holdings_temporary_location_name,
	--h.instance_id,
	h.shelving_title,
	/* including item_id to show that we have multiple records for an individual item */
    i.id AS item_id,
	--iploc.id AS items_permanent_location_id,
	iploc.name AS items_permanent_location_name,
	--itloc.id AS items_temporary_location_id,
	itloc.name AS items_temporary_location_name,
	i.barcode,
	i.item_level_call_number,
	i.volume,
	i.enumeration,
	i.chronology,
	json_extract_path_text(i.data, 'status', 'name') AS item_status_name,
	json_extract_path_text(i.data, 'status', 'date') AS item_status_date,
	json_extract_path_text(i.data, 'notes', 'description') AS item_notes,
	'{ "copyNumbers": ' :: varchar || 
        COALESCE(json_extract_path_text(i.data, 'copyNumbers'), '[]' :: varchar) ||
		'}' :: varchar AS copy_numbers,
	--l.id AS loan_id,
	--cosp.id AS checkout_service_point_id,
	cosp.name AS checkout_service_point_name,
	--cisp.id AS checkin_service_point_id,
	cisp.name AS checkin_service_point_name,
	/* Is renewal count needed for the "In transit" loan? Or is it just needed for the 
	 * overall circulation of the item? I included loans_and_renewals separately below,
	 * so I would expect to want to remove this per-loan renewal count from the report output.
	 */
	l.renewal_count AS loan_renewal_count, 
	--ins.id AS instance_id,
	ins.cataloged_date,
    json_extract_path_text(ins.data, 'publication', 'dateOfPulication') AS instance_publication_date,
    --m.id AS material_type_id, 
	m.name AS material_type_name,
	--itsp.id AS in_transit_destination_service_point_id,
	itsp.name AS in_transit_destination_service_point_name,
	--tl.id AS effective_location_id,
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
        volume,
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
/* Not sure if, for performance, each table joined in should have a select statement
 * to limit to specific columns, or if it's okay to join entire table.
 */
LEFT JOIN holdings AS h
	ON i.holdings_record_id = h.id
LEFT JOIN loans AS l
	ON i.id = l.item_id 
LEFT join instances AS ins
	ON h.instance_id = ins.id
LEFT join material_types AS m
	ON i.material_type_id = m.id
LEFT JOIN service_points AS cosp 
	ON l.checkout_service_point_id=cosp.id 
LEFT JOIN service_points AS cisp 
	ON l.checkin_service_point_id=cisp.id 
LEFT JOIN service_points AS itsp 
	ON i.in_transit_destination_service_point_id=itsp.id 
LEFT JOIN locations AS hploc
	ON h.permanent_location_id = hploc.id
LEFT JOIN locations AS htloc
	ON h.temporary_location_id = htloc.id
LEFT JOIN locations AS iploc
	ON i.permanent_location_id = iploc.id
LEFT JOIN locations AS itloc
	ON i.temporary_location_id = itloc.id
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

     	
   
