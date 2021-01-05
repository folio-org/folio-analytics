

/* Change the lines below to adjust the date, item status, and location filters */
WITH parameters AS (
    SELECT
        '2000-01-01' :: DATE AS start_date,
        '2021-01-01' :: DATE AS end_date,
        'In transit' :: VARCHAR AS item_status_filter, --  'Checked out', 'Available', 'In transit'
		---- Fill out one location or service point filter, leave others blank ----
        '' ::VARCHAR AS item_permanent_location_filter, -- 'Main Library'
        '' ::VARCHAR AS item_temporary_location_filter, -- 'Annex'
        '' ::VARCHAR AS holdings_permanent_location_filter, -- 'Main Library'
        '' ::VARCHAR AS holdings_temporary_location_filter, -- 'Main Library'
        '' ::VARCHAR AS effective_location_filter, -- 'Main Library'
        '' ::VARCHAR AS in_transit_destination_service_point_filter -- 'Circ Desk 1'
        ),
        
---------- SUB-QUERIES/TABLES ----------
ranked_loans AS (
    SELECT 
        item_id,
        id AS loan_id,
        return_date AS loan_return_date,
        item_status,
        rank() OVER (
            PARTITION BY item_id
            ORDER BY return_date DESC
        ) AS return_date_ranked
    FROM public.circulation_loans
    WHERE
    	item_status = (SELECT item_status_filter FROM parameters) 
  	AND 
        return_date :: DATE >= (SELECT start_date FROM parameters)
    AND return_date :: DATE <  (SELECT end_date FROM parameters)    
),
/* This should be pulling the latest loan for each item. Will want to test again with real data. */
latest_loan AS (
    SELECT 
    	item_id,
        loan_id,
       item_status,
       loan_return_date
    FROM ranked_loans
    WHERE ranked_loans.return_date_ranked = 1
)
---------- MAIN QUERY ----------
SELECT 
	(SELECT start_date :: VARCHAR FROM parameters) ||
        ' to ' :: VARCHAR ||
        (SELECT end_date :: VARCHAR FROM parameters) AS date_range,
        ll.item_status,
        li.item_id,
        ll.loan_id,
        ll.loan_return_date,
        he.holdings_id,
        he.permanent_location_id AS holdings_permanent_location_id,
        he.permanent_location_name AS holdings_permanent_location_name,
        he.temporary_location_id AS holdings_temporary_location_id,
        he.temporary_location_name AS holdings_temporary_location_name,
		he.shelving_title,
		li.current_item_permanent_location_id,
		li.current_item_permanent_location_name,
		li.current_item_temporary_location_id,
		li.current_item_temporary_location_name,
		li.current_item_effective_location_id,
		li.current_item_effective_location_name,
		it.barcode,
		it.call_number,
		it.enumeration,
		it.chronology,
		it.copy_number,
		--cataloged_date, can this be brought into holdings_ext table, along with instance_id and instance_publication_date?
		--item_notes, can this be brought into the loans_items table from inventory_items?
		li.in_transit_destination_service_point_id,
		li.in_transit_destination_service_point_name,
		li.checkout_service_point_id,
		li.checkout_service_point_name,
		li.checkin_service_point_id,
		li.checkin_service_point_name,
		lc.num_loans,
		lc.num_renewals,
		li.material_type_id,
		li.material_type_name
	--	volume --can't find
		FROM 
		folio_reporting.loans_items AS li
		INNER JOIN latest_loan AS ll
			ON li.loan_id = ll.loan_id 
		LEFT JOIN folio_reporting.item_ext AS it
			ON li.item_id = it.item_id
		LEFT JOIN folio_reporting.holdings_ext AS he
			ON li.holdings_record_id = he.holdings_id
		LEFT JOIN folio_reporting.loans_renewal_count AS lc
			ON li.item_id = lc.item_id
		WHERE 
         (li.current_item_permanent_location_name = (SELECT item_permanent_location_filter FROM parameters)
					OR (SELECT item_permanent_location_filter FROM parameters) = '')
    AND  (li.current_item_temporary_location_name = (SELECT item_temporary_location_filter FROM parameters)
 					OR (SELECT item_temporary_location_filter FROM parameters) = '')
    AND  (he.permanent_location_name = (SELECT holdings_permanent_location_filter FROM parameters)
					OR (SELECT holdings_permanent_location_filter FROM parameters) = '')
    AND  (he.temporary_location_name = (SELECT holdings_temporary_location_filter FROM parameters)
					OR (SELECT holdings_temporary_location_filter FROM parameters) = '')
    AND (current_item_effective_location_name = (SELECT effective_location_filter FROM parameters)
					OR (SELECT effective_location_filter FROM parameters) = '')
    AND   (li.in_transit_destination_service_point_name = (SELECT in_transit_destination_service_point_filter FROM parameters)
					OR (SELECT in_transit_destination_service_point_filter FROM parameters) = '')
 ;
		