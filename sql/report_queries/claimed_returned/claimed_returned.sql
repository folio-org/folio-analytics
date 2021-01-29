/*FIELDS INCLUDED IN SAMPLE:

A report of claimed return loans with helpful details from item, holdings, and instance
 
FILTERS: loan item status, loan date range, location name (permanent, temporary, effective)

AGGREGATION: total historical loan sum and renewal sum included (not date-range bound)
 */
WITH parameters AS (
    SELECT
        /* Search loans with this status */
        --change status to Claimed returned, which does not currently exist in the test data.
        'Checked out'::varchar AS item_status_filter, --Claimed returned
        /* Choose a start and end date for the loans period */
        '2000-01-01'::date AS start_date,
        '2022-01-01'::date AS end_date,
        /* Fill in a location name, OR leave blank for all locations */
        ''::varchar AS current_item_permanent_location_filter, --Online, Annex, Main Library
        ''::varchar AS current_item_temporary_location_filter, --Online, Annex, Main Library
        ''::varchar AS current_item_effective_location_filter, --Online, Annex, Main Library 
        ''::varchar AS current_item_permanent_location_institution_filter, -- 'Københavns Universitet','Montoya College'
        ''::varchar AS current_item_permanent_location_campus_filter, -- 'Main Campus','City Campus','Online'
        ''::varchar AS current_item_permanent_location_library_filter -- 'Datalogisk Institut','Adelaide Library'
),
-- CTEs
items_with_notes AS (
    SELECT
        item_id,
        string_agg(DISTINCT note, '|') AS item_notes
    FROM
        folio_reporting.item_notes
    GROUP BY
        item_id
),
instances_with_publication_dates AS (
    SELECT
        instance_id,
        string_agg(DISTINCT date_of_publication, '|') AS dates_of_publication
    FROM
        folio_reporting.instance_publication
    GROUP BY
        instance_id
)
SELECT
    (SELECT start_date::varchar FROM parameters) || ' to ' || (SELECT end_date::varchar FROM parameters) AS date_range,
    li.loan_id,
    li.item_id,
    li.loan_date,
    li.loan_due_date,
    li.loan_return_date,
    json_extract_path_text(l.data, 'claimedReturnedDate')::date AS claimed_returned_date,
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
    json_extract_path_text(uu.data, 'personal', 'firstName') AS first_name,
    json_extract_path_text(uu.data, 'personal', 'middleName') AS middle_name,
    json_extract_path_text(uu.data, 'personal', 'lastName') AS last_name,
    json_extract_path_text(uu.data, 'personal', 'email') AS email
FROM
    folio_reporting.loans_items AS li
    LEFT JOIN public.user_users AS uu ON li.user_id = uu.id
    LEFT JOIN public.circulation_loans AS l ON li.loan_id = l.id
    LEFT JOIN folio_reporting.item_ext AS ie ON li.item_id = ie.item_id
    LEFT JOIN items_with_notes AS nn ON li.item_id = nn.item_id
    LEFT JOIN folio_reporting.holdings_ext AS he ON ie.holdings_record_id = he.holdings_id
    LEFT JOIN public.inventory_instances AS ii ON he.instance_id = ii.id
    LEFT JOIN instances_with_publication_dates AS pd ON he.instance_id = pd.instance_id
    LEFT JOIN folio_reporting.instance_publication AS ip ON he.instance_id = ip.instance_id
    LEFT JOIN folio_reporting.loans_renewal_count AS lrc ON li.item_id = lrc.item_id
WHERE (li.current_item_permanent_location_name = (SELECT current_item_permanent_location_filter FROM parameters)
        OR '' = (SELECT current_item_permanent_location_filter FROM parameters))
    AND (li.current_item_temporary_location_name = (SELECT current_item_temporary_location_filter FROM parameters)
        OR '' = (SELECT current_item_temporary_location_filter FROM parameters))
    AND (li.current_item_effective_location_name = (SELECT current_item_effective_location_filter FROM parameters)
        OR '' = (SELECT current_item_effective_location_filter FROM parameters))
    AND (li.current_item_permanent_location_library_name = (SELECT current_item_permanent_location_library_filter FROM parameters)
        OR '' = (SELECT current_item_permanent_location_library_filter FROM parameters))
    AND (li.current_item_permanent_location_institution_name = (SELECT current_item_permanent_location_institution_filter FROM parameters)
        OR '' = (SELECT current_item_permanent_location_institution_filter FROM parameters))
    AND (li.current_item_permanent_location_campus_name = (SELECT current_item_permanent_location_campus_filter FROM parameters)
        OR '' = (SELECT current_item_permanent_location_campus_filter FROM parameters))
    AND li.item_status = (SELECT item_status_filter FROM parameters)
    AND li.loan_date >= (SELECT start_date FROM parameters)
    AND li.loan_date < (SELECT end_date FROM parameters);

