/* FIELDS INCLUDED IN REPORT SAMPLE:
 service point name
 date (of staff action; either loan date or return date/system return date)
 day of week
 hour of day
 material type
 transaction type - Checkin or Checkout 
 item effective location at checkout
 item status from loan
 count of loan id

AGGREGATION: date, hour of day, service point, material type,
 transaction type, item status, item effective location

FILTERS: action date

Note: This uses two complete queries - one for checkin actions that match
date filter, then checkout actions that match, then just unions them together
 */
/* Change the lines below to adjust the date filter */
WITH parameters AS (
    SELECT
        '2000-01-01'::date AS start_date,
        '2022-01-01'::date AS end_date
),
checkout_actions AS (
    SELECT
        checkout_service_point_name AS service_point_name,
        loan_date::date AS action_date,
        to_char(loan_date, 'Day') AS day_of_week,
    extract(hours FROM loan_date) AS hour_of_day,
    material_type_name,
    'Checkout'::varchar AS action_type,
    item_effective_location_name_at_check_out,
    item_status,
    count(loan_id) AS ct
FROM
    folio_reporting.loans_items
    WHERE
        loan_date >= (SELECT start_date FROM parameters)
        AND loan_date < (SELECT end_date FROM parameters)
    GROUP BY
        service_point_name,
        action_date,
        day_of_week,
        hour_of_day,
        material_type_name,
        item_effective_location_name_at_check_out,
        item_status
),
simple_return_dates AS (
    SELECT
        checkin_service_point_name AS service_point_name,
        coalesce(system_return_date::timestamptz at time zone 'UTC', 
            loan_return_date::timestamptz at time zone 'UTC') AS action_date,
        material_type_name,
        'Checkin'::varchar AS action_type,
        item_effective_location_name_at_check_out,
        item_status,
        loan_id
    FROM
        folio_reporting.loans_items
),
checkin_actions AS (
    SELECT
        service_point_name,
        action_date::date AS action_date,
        to_char(action_date, 'Day') AS day_of_week,
        extract(hours FROM action_date) AS hour_of_day,
        material_type_name,
        action_type,
        item_effective_location_name_at_check_out,
        item_status,
        count(loan_id) AS ct
    FROM
        simple_return_dates
    WHERE
        action_date >= (SELECT start_date FROM parameters)
        AND action_date < (SELECT end_date FROM parameters)
    GROUP BY
        service_point_name,
        action_date,
        day_of_week,
        hour_of_day,
        material_type_name,
        action_type,
        item_effective_location_name_at_check_out,
        item_status
)
SELECT
    service_point_name,
    action_date,
    day_of_week,
    hour_of_day,
    material_type_name,
    action_type,
    item_effective_location_name_at_check_out,
    item_status,
    ct
FROM
    checkout_actions
UNION ALL
SELECT
    service_point_name,
    action_date,
    day_of_week,
    hour_of_day,
    material_type_name,
    action_type,
    item_effective_location_name_at_check_out,
    item_status,
    ct
FROM
    checkin_actions
ORDER BY
    service_point_name,
    action_date,
    day_of_week,
    hour_of_day,
    material_type_name,
    action_type,
    item_effective_location_name_at_check_out,
    item_status;

