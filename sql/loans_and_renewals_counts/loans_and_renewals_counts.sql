/* FIELDS INCLUDED:
 * (id fields are used as table joins and do not get outputted in the final table)
Loans table
	Loan id 
	Loan date
	loan due date
	Loan return date
	Loan status
	Loan policy id
	Loan count
	Loan renewal count
	Item id 
	Patron group id at checkout
Items table
	Item id 
	Material type id 
	Permanent location id 
	Temporary location id 
	Effective location id
	Permanent loan type id
	Temporary loan type id
	Material types table
	Material type id
	Material type name
Locations table
	Location id
	Location name
	Library id
	Campus id
	Institution id
Libraries table
	Library id
	Library name
Campuses Table
	Campus id
	Campus name
Institutions table
	Institution id
	Institution name
Groups table
	Group id
	Group name
Loan policies table
	Loan id
	Loan name
Loan type table
	Loan type id
	Loan type name
*/

WITH parameters AS (
	SELECT
		/* Choose a start and end date for the loans period */
        '2000-01-01' :: DATE AS start_date,
        '2021-01-01' :: DATE AS end_date,
        /* Fill one out, leave others blank to filter by location */
		'Main Library' :: VARCHAR AS items_permanent_location_filter, --Online, Annex, Main Library
		'' :: VARCHAR AS items_temporary_location_filter, --Online, Annex, Main Library
		'' :: VARCHAR AS items_effective_location_filter, --Online, Annex, Main Library
		/* The following connect to the item's permanent location */
		'' ::VARCHAR AS institution_filter, -- 'KÃ¸benhavns Universitet','Montoya College'
        '' ::VARCHAR AS campus_filter, -- 'Main Campus','City Campus','Online'
        '' ::VARCHAR AS library_filter -- 'Datalogisk Institut','Adelaide Library'
        ),
        --SUB-QUERIES
location_filtering AS (
    SELECT
        i.id AS item_id,
	    i.permanent_location_id AS perm_location_id,
	    i.temporary_location_id AS temp_location_id,
	    i.effective_location_id AS effec_location_id,
        itpl.id AS item_perm_loc_id,
        itpl."name" AS perm_location_name,
 	    ittl.id AS item_temp_loc_id,
        ittl."name" AS temp_location_name,
	    itel.id AS loc_id,
        itel."name" AS effective_location_name,
        lib."name" AS lib_name,
        cmp."name" AS campus_name,
        ins."name" AS institute_name
    FROM inventory_items AS i
	LEFT JOIN inventory_locations AS itpl
        ON i.permanent_location_id = itpl.id
    LEFT JOIN inventory_locations AS ittl
        ON i.temporary_location_id = ittl.id
    LEFT JOIN inventory_locations AS itel
        ON i.effective_location_id = itel.id
    LEFT JOIN inventory_libraries AS lib
        ON itpl.library_id = lib.id
    LEFT JOIN inventory_campuses AS cmp
        ON itpl.campus_id = cmp.id
    LEFT JOIN inventory_institutions AS ins
        ON itpl.institution_id = ins.id
    WHERE
		itpl."name" = (SELECT items_permanent_location_filter FROM parameters)
		OR ittl."name" = (SELECT items_temporary_location_filter FROM parameters)
		OR itel."name" = (SELECT items_effective_location_filter FROM parameters)
		OR lib."name" = (SELECT library_filter FROM parameters)
		OR cmp."name" = (SELECT campus_filter FROM parameters)
		OR ins."name" = (SELECT institution_filter FROM parameters)
),
loan_count AS (
	SELECT 
		id, 
		COUNT(id) AS num_loans,
		SUM(renewal_count) AS num_renewals
	FROM circulation_loans
	GROUP BY id
),
loan_details AS (
	SELECT 
		l.loan_date,
		l.due_date AS loan_due_date,
		l.return_date AS loan_return_date,
		l.item_status AS loan_status,
		l.item_id,
		l.id AS loan_id,
		lc.num_loans,
		lc.num_renewals,
		l.patron_group_id_at_checkout,
		i.material_type_id,
		mt.name AS material_type_name,
		g.group AS patron_group_name,
		lp.name AS loan_policy_name,
		plt.name AS permanent_loan_type_name,
		tlt.name AS temporary_loan_type_name,
		location_filtering.temp_location_name,
		location_filtering.perm_location_name,
		location_filtering.effective_location_name,
		location_filtering.lib_name,
		location_filtering.campus_name,
		location_filtering.institute_name
	FROM circulation_loans as l
	LEFT JOIN inventory_items AS i
        ON l.loan_policy_id=i.id
	LEFT JOIN circulation_loan_policies as lp
	    ON l.loan_policy_id=lp.id
	LEFT JOIN inventory_loan_types as plt
	    ON i.permanent_loan_type_id=plt.id
	LEFT JOIN inventory_loan_types as tlt
        ON i.temporary_loan_type_id=tlt.id
	LEFT JOIN inventory_material_types as mt
        ON i.material_type_id=mt.id
	LEFT JOIN user_groups as g
        ON l.patron_group_id_at_checkout=g.id
	LEFT JOIN loan_count AS lc
        ON l.id=lc.id
	LEFT JOIN location_filtering 
        ON l.item_id= location_filtering.item_id)
--MAIN QUERY
SELECT 
	(SELECT start_date :: VARCHAR FROM parameters) ||
     ' to ' :: VARCHAR ||
    (SELECT end_date :: VARCHAR FROM parameters) AS date_range,
		loan_due_date,
		loan_return_date,
		loan_status,
		num_loans,
		num_renewals,
		patron_group_name,
		material_type_name,
		loan_policy_name,
		permanent_loan_type_name,
		temporary_loan_type_name,
		loan_date,
		temp_location_name,
		perm_location_name,
		effective_location_name,
		lib_name,
		campus_name,
		institute_name
	FROM loan_details
WHERE loan_date >= (SELECT start_date FROM parameters)
AND loan_date < (SELECT end_date FROM parameters)
;
