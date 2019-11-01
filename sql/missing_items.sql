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

The locations table join will depend on which of the five locations are required as a filter 
for the report: item permanent location, item temporary location, holdings permanent location, 
holdings temporary location, or effective location*/

/* Change the lines below to adjust the date, item status, and location filters */
WITH parameters AS (
    SELECT
        '2000-01-01' :: DATE AS start_date,
        '2020-01-01' :: DATE AS end_date,
        'Available' :: varchar AS item_status_filter,
        /*choose only ONE of the following location parameters*/
		'Main Library' :: varchar AS location_filter,
		'Main Library check out desk' AS transit_destination_service_point_filter,
		'Annex' AS effective_location_filter
        )
SELECT
	(SELECT start_date :: VARCHAR FROM parameters) ||
        ' to ' :: VARCHAR ||
        (SELECT end_date :: VARCHAR FROM parameters) AS date_range,
	h.id AS holdings_id,
	h.permanent_location_ID AS holdings_permanent_location_id,
	h.temporary_location_id AS holdings_temporary_location_id,
	h.instance_id,
	h.shelving_title,
        i.id AS item_id,
	i.holdings_record_id,
	i.permanent_location_id AS items_permanent_location_id,
	i.temporary_location_id AS items_temporary_location_id,
	i.in_transit_destination_service_point_id,
	i.barcode,
	i.material_type_id,
	i.item_level_call_number,
	i.Volume,
	i.Enumeration,
	i.Chronology,
	json_extract_path_text(i.data, 'status', 'name') AS item_status_name,
	json_extract_path_text(i.data, 'status', 'date') AS item_status_date,
	json_extract_path_text(i.data, 'notes', 'description') AS item_notes,
	'{ "copyNumbers": ' :: varchar || 
        COALESCE(json_extract_path_text(i.data, 'copyNumbers'), '[]' :: varchar) ||
		'}' :: varchar AS copy_numbers,
	l.id AS loan_ID,
	l.item_id,
	l.checkout_service_point_ID,
	l.checkin_service_point_ID,
	l.renewal_count AS loan_renewal_count,
	ins.id,
	ins.cataloged_date,
        json_extract_path_text(ins.data, 'publication', 'dateOfPulication') AS item_publication_date,
        m.ID, 
	m."name" AS material_type,
	loc.ID AS location_ID,
	loc."name" AS location_name,
	sp.ID,
	sp."name" AS transit_destination_service_point_name,
	tl.id,
	tl.temp_location AS effective_location
	FROM items AS i
LEFT JOIN holdings AS h
	ON i.holdings_record_id = h.id
LEFT JOIN loans AS l
	ON i.id = l.item_id 
LEFT join instances AS ins
	ON h.instance_id = ins.id
LEFT join material_types AS m
	ON i.material_type_id = m.id
LEFT JOIN service_points AS sp 
	ON i.in_transit_destination_service_point_id=sp.id 
LEFT JOIN locations AS loc
	ON i.permanent_location_id = loc.id
LEFT JOIN temp_loans AS tl
     ON l.id = tl.id
	WHERE
   json_extract_path_text(i.data, 'status', 'name') =
        (SELECT item_status_filter FROM parameters) 
 AND Item_status_date >= (SELECT start_date FROM parameters)
 AND item_status_date <  (SELECT end_date FROM parameters)
 /*choose only ONE of the three statements below, to match with choice of location parameters*/
 AND loc."name" = (SELECT location_filter FROM parameters)
 AND effective_location = (SELECT effective_location_filter FROM parameters)
 AND transit_destination_service_point_name = (SELECT transit_destination_service_point_filter FROM parameters)
 ;
  /* To see how often an item was checked out, including renewals, I need to count the number of loans for 
   each item (count of loan_ID by itemID), and then add that to the renewal counts.
   Code below is incorrect. 
SELECT COUNT(l.id) AS number_of_checkouts
GROUP BY i.itemID
SELECT (number_of_checkouts + l.renewal_count) AS times_loaned
BY i.itemID; */

     	
   
