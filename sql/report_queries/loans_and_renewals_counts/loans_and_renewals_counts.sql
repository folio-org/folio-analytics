/* Report produces a list of individual loans which can then
 * be grouped and summed to create loans and renewals counts.
 * 
 * FIELDS INCLUDED:
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
        '2000-01-01'::date AS start_date,
        '2022-01-01'::date AS end_date,
        /* Fill one out, leave others blank to filter by location */
        'Main Library'::varchar AS items_permanent_location_filter, --Online, Annex, Main Library
        ''::varchar AS items_temporary_location_filter, --Online, Annex, Main Library
        ''::varchar AS items_effective_location_filter, --Online, Annex, Main Library
        /* The following connect to the item's permanent location */
        ''::varchar AS institution_filter, -- 'KÃ¸benhavns Universitet','Montoya College'
        ''::varchar AS campus_filter, -- 'Main Campus','City Campus','Online'
        ''::varchar AS library_filter -- 'Datalogisk Institut','Adelaide Library'
)
    --MAIN QUERY
    SELECT
        (
            SELECT
                start_date::varchar
            FROM
                parameters) || ' to '::varchar || (
        SELECT
            end_date::varchar
        FROM
            parameters) AS date_range,
    li.loan_date::date,
    li.loan_due_date AS loan_due_date,
    li.loan_return_date AS loan_return_date,
    li.loan_status AS loan_status,
    '1'::int AS num_loans, -- each row is a single loan
    li.renewal_count AS num_renewals,
    li.patron_group_name AS patron_group_name,
    li.material_type_name AS material_type_name,
    li.loan_policy_name AS loan_policy_name,
    li.permanent_loan_type_name AS permanent_loan_type_name,
    li.temporary_loan_type_name AS temporary_loan_type_name,
    li.current_item_permanent_location_name AS permanent_location_name,
    li.current_item_temporary_location_name AS temporary_location_name,
    li.current_item_effective_location_name AS effective_location_name,
    li.current_item_permanent_location_library_name AS permanent_location_library_name,
    li.current_item_permanent_location_campus_name AS permanent_location_campus_name,
    li.current_item_permanent_location_institution_name AS permanent_location_institution_name
FROM
    folio_reporting.loans_items AS li
WHERE
    loan_date >= (
        SELECT
            start_date
        FROM
            parameters)
    AND loan_date < (
        SELECT
            end_date
        FROM
            parameters)
    AND (li.current_item_permanent_location_name = (
            SELECT
                items_permanent_location_filter
            FROM
                parameters)
            OR '' = (
                SELECT
                    items_permanent_location_filter
                FROM
                    parameters))
        AND (li.current_item_temporary_location_name = (
                SELECT
                    items_temporary_location_filter
                FROM
                    parameters)
                OR '' = (
                    SELECT
                        items_temporary_location_filter
                    FROM
                        parameters))
            AND (li.current_item_effective_location_name = (
                    SELECT
                        items_effective_location_filter
                    FROM
                        parameters)
                    OR '' = (
                        SELECT
                            items_effective_location_filter
                        FROM
                            parameters))
                AND (li.current_item_permanent_location_library_name = (
                        SELECT
                            library_filter
                        FROM
                            parameters)
                        OR '' = (
                            SELECT
                                library_filter
                            FROM
                                parameters))
                    AND (li.current_item_permanent_location_campus_name = (
                            SELECT
                                campus_filter
                            FROM
                                parameters)
                            OR '' = (
                                SELECT
                                    campus_filter
                                FROM
                                    parameters))
                        AND (li.current_item_permanent_location_institution_name = (
                                SELECT
                                    institution_filter
                                FROM
                                    parameters)
                                OR '' = (
                                    SELECT
                                        institution_filter
                                    FROM
                                        parameters));

