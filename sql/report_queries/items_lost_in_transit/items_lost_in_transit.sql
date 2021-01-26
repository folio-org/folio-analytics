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

FILTERS: item status type, item status date, location

AGGREGATION: number of loans for each item, loan renewal counts, sum of these two aggregations

Note: We are using item status 'In transit' to indicate that an item is missing.
You can set the date range to specify that it is older, closed loans with "In transit"
status that constitute missing items. 
 */
/* Change the lines below to adjust the date, item status, and location filters */
WITH parameters AS (
    SELECT
        '2000-01-01'::DATE AS start_date,
        '2022-01-01'::DATE AS end_date,
        'In transit'::VARCHAR AS item_status_filter, --  'Checked out', 'Available', 'In transit'
        ---- Fill out one location or service point filter, leave others blank ----
        ''::varchar AS item_permanent_location_filter, -- 'Main Library'
''::varchar AS item_temporary_location_filter, -- 'Annex'
''::varchar AS holdings_permanent_location_filter, -- 'Main Library'
''::varchar AS holdings_temporary_location_filter, -- 'Main Library'
''::varchar AS effective_location_filter, -- 'Main Library'
''::varchar AS in_transit_destination_service_point_filter -- 'Circ Desk 1'
),
---------- SUB-QUERIES/TABLES ----------
ranked_loans AS (
    SELECT
        item_id,
        id AS loan_id,
        return_date AS loan_return_date,
        item_status,
        rank() OVER (PARTITION BY item_id ORDER BY return_date DESC) AS return_date_ranked
FROM
    public.circulation_loans
    WHERE
        item_status = (
            SELECT
                item_status_filter
            FROM
                parameters)
            AND return_date::DATE >= (
                SELECT
                    start_date
                FROM
                    parameters)
                AND return_date::DATE < (
                    SELECT
                        end_date
                    FROM
                        parameters)
),
/* This should be pulling the latest loan for each item. Will want to test again with real data. */
latest_loan AS (
    SELECT
        item_id,
        loan_id,
        item_status,
        loan_return_date
    FROM
        ranked_loans
    WHERE
        ranked_loans.return_date_ranked = 1
),
item_notes_list AS (
    SELECT
        item_id,
        string_agg(DISTINCT note, '|'::text) AS notes_list
    FROM
        folio_reporting.item_notes
    GROUP BY
        item_id
),
publication_dates_list AS (
    SELECT
        instance_id,
        string_agg(DISTINCT date_of_publication, '|'::text) AS publication_dates_list
    FROM
        folio_reporting.instance_publication
    GROUP BY
        instance_id)
    ---------- MAIN QUERY ----------
    SELECT
        (
            SELECT
                start_date::VARCHAR
            FROM
                parameters) || ' to '::VARCHAR || (
            SELECT
                end_date::VARCHAR
            FROM
                parameters) AS date_range,
        li.item_id,
        ie.title,
        he.shelving_title,
        ll.item_status,
        ll.loan_return_date,
        li.checkout_service_point_name,
        li.checkin_service_point_name,
        li.in_transit_destination_service_point_name,
        it.barcode,
        it.call_number,
        it.enumeration,
        it.chronology,
        it.copy_number,
        it.volume,
        he.permanent_location_name AS holdings_permanent_location_name,
        he.temporary_location_name AS holdings_temporary_location_name,
        li.current_item_permanent_location_name,
        li.current_item_temporary_location_name,
        li.current_item_effective_location_name,
        ie.cataloged_date,
        pd.publication_dates_list,
        nl.notes_list,
        li.material_type_name,
        lc.num_loans,
        lc.num_renewals
    FROM
        folio_reporting.loans_items AS li
        INNER JOIN latest_loan AS ll ON li.loan_id = ll.loan_id
        LEFT JOIN folio_reporting.item_ext AS it ON li.item_id = it.item_id
        LEFT JOIN item_notes_list AS nl ON li.item_id = nl.item_id
        LEFT JOIN folio_reporting.holdings_ext AS he ON li.holdings_record_id = he.holdings_id
        LEFT JOIN folio_reporting.instance_ext AS ie ON he.instance_id = ie.instance_id
        LEFT JOIN folio_reporting.instance_publication AS ip ON ie.instance_id = ip.instance_id
        LEFT JOIN publication_dates_list AS pd ON ie.instance_id = pd.instance_id
        LEFT JOIN folio_reporting.loans_renewal_count AS lc ON li.item_id = lc.item_id
    WHERE (li.current_item_permanent_location_name = (
            SELECT
                item_permanent_location_filter
            FROM
                parameters)
            OR (
                SELECT
                    item_permanent_location_filter
                FROM
                    parameters) = '')
        AND (li.current_item_temporary_location_name = (
                SELECT
                    item_temporary_location_filter
                FROM
                    parameters)
                OR (
                    SELECT
                        item_temporary_location_filter
                    FROM
                        parameters) = '')
            AND (he.permanent_location_name = (
                    SELECT
                        holdings_permanent_location_filter
                    FROM
                        parameters)
                    OR (
                        SELECT
                            holdings_permanent_location_filter
                        FROM
                            parameters) = '')
                AND (he.temporary_location_name = (
                        SELECT
                            holdings_temporary_location_filter
                        FROM
                            parameters)
                        OR (
                            SELECT
                                holdings_temporary_location_filter
                            FROM
                                parameters) = '')
                    AND (current_item_effective_location_name = (
                            SELECT
                                effective_location_filter
                            FROM
                                parameters)
                            OR (
                                SELECT
                                    effective_location_filter
                                FROM
                                    parameters) = '')
                        AND (li.in_transit_destination_service_point_name = (
                                SELECT
                                    in_transit_destination_service_point_filter
                                FROM
                                    parameters)
                                OR (
                                    SELECT
                                        in_transit_destination_service_point_filter
                                    FROM
                                        parameters) = '');

