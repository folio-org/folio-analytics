/* Item is overdue if number of days overdue (number of days between
 * today and due date) is greater than 0.
 * 
 * Note: would like to include number of notices sent, but notices
 * data are not yet available in LDP
 * 
 * FILTERS: 
 * number of days a loan is overdue, 
 * location name, and patron group name 
 * if needed, e.g. Borrow Direct
 * */

WITH parameters AS (
    SELECT
        /* replace the placeholder number with the number of days overdue that is needed for this report */
        '2000'::integer AS days_overdue_filter, -- doesn't work if empty
        /* Fill in a location name, OR leave blank for all locations */
        ''::varchar AS current_item_permanent_location_filter, --Online, Annex, Main Library
        ''::varchar AS current_item_temporary_location_filter, --Online, Annex, Main Library
        ''::varchar AS current_item_effective_location_filter, --Online, Annex, Main Library 
        /*Choose a patron group name or leave blank*/
        ''AS patron_group_filter --can use for Borrow Direct or ILL
),
days AS (
    SELECT 
        loan_id,
        DATE_PART('day', NOW() - loan_due_date) AS days_overdue
    FROM folio_reporting.loans_items
)
SELECT
    li.patron_group_name,
    uu.id AS patron_id,
    uu.barcode AS patron_barcode,
    json_extract_path_text(uu.data, 'personal', 'lastName') AS last_name,
    json_extract_path_text(uu.data, 'personal', 'firstName') AS first_name,
    json_extract_path_text(uu.data, 'personal', 'email') AS email,
    li.current_item_effective_location_name,
    li.current_item_permanent_location_name,
    li.current_item_temporary_location_name,
    ie.call_number,
    li.chronology,
    li.copy_number,
    li.enumeration,
    li.barcode AS item_barcode,
    li.loan_date,
    cl.renewal_count AS loan_renewal_count,
    li.loan_due_date,
    -- add number of notices sent when available
    days.days_overdue    
FROM
    folio_reporting.loans_items AS li
    LEFT JOIN public.user_users AS uu ON li.user_id = uu.id
    LEFT JOIN folio_reporting.item_ext AS ie ON li.item_id = ie.item_id
    LEFT JOIN public.circulation_loans AS cl ON li.loan_id = cl.id
    LEFT JOIN days ON days.loan_id=li.loan_id
    WHERE (days.days_overdue > 0 AND days.days_overdue <= (SELECT days_overdue_filter FROM parameters))
    AND (li.patron_group_name = (SELECT patron_group_filter FROM parameters)
    	OR '' = (SELECT patron_group_filter FROM parameters))
    AND (li.current_item_permanent_location_name = (SELECT current_item_permanent_location_filter FROM parameters)
        OR '' = (SELECT current_item_permanent_location_filter FROM parameters))
    AND (li.current_item_temporary_location_name = (SELECT current_item_temporary_location_filter FROM parameters)
        OR '' = (SELECT current_item_temporary_location_filter FROM parameters))
    AND (li.current_item_effective_location_name = (SELECT current_item_effective_location_filter FROM parameters)
        OR '' = (SELECT current_item_effective_location_filter FROM parameters))
   ;
