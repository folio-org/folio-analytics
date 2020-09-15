/* FIELDS INCLUDED IN REPORT SAMPLE:
    service point name
    service point display name
    date (of staff action; either loan date or system return date)
    day of week
    hour of day
    item status before action
    item effective location before action
    material type
    transaction type
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
        '2000-01-01' :: DATE AS start_date,
        '2021-01-01' :: DATE AS end_date
),
loans_checkout AS (
    SELECT
	    id,
        -- item_effective_location_at_check_out,
        json_extract_path_text(data, 'itemEffectiveLocationAtCheckOut') AS item_effective_location_at_check_out,
        checkout_service_point_id,
        loan_date,
        item_id,
        item_status
    FROM circulation_loans
),
simple_loan_dates as (
    SELECT
	    id,
        item_effective_location_at_check_out,
        checkout_service_point_id,
        loan_date :: DATE AS loan_date,
        to_char(loan_date , 'Day') AS day_of_week,
        EXTRACT(hours from loan_date ) AS hour_of_day,
        item_id,
        item_status
    FROM loans_checkout
),
checkout_actions AS (
    SELECT
        sp.name AS service_point_name,
        sp.discovery_display_name AS service_point_display_name,
        l.loan_date AS action_date,
        l.day_of_week,
        l.hour_of_day,
        m.name AS material_type,
        'Checkout' :: VARCHAR AS action_type,
        effloc.name AS effective_location,
        l.item_status AS item_status,
        count(l.id) AS ct
    FROM simple_loan_dates AS l
    LEFT JOIN inventory_locations AS effloc
        ON l.item_effective_location_at_check_out = effloc.id
    LEFT JOIN inventory_items AS i
        ON l.item_id = i.id
    LEFT JOIN inventory_service_points AS sp
        ON l.checkout_service_point_id = sp.id
    LEFT JOIN inventory_material_types AS m
        ON i.material_type_id = m.id
    WHERE
        loan_date >= (SELECT start_date FROM parameters)
    AND loan_date <  (SELECT end_date FROM parameters)
    GROUP BY
        sp.name,
        sp.discovery_display_name,
        l.loan_date,
        l.day_of_week,
        l.hour_of_day,
        m.name,
        effloc.name,
        l.item_status        
),
loans_checkin AS ( 
    SELECT
	    id,
        -- item_effective_location_at_check_out,
        json_extract_path_text(data, 'itemEffectiveLocationAtCheckOut') AS item_effective_location_at_check_out,
        checkin_service_point_id,
        COALESCE(system_return_date, return_date :: TIMESTAMPTZ AT TIME ZONE 'UTC' ) AS return_date,
        item_id,
        item_status
    FROM circulation_loans
),
simple_return_dates AS ( 
    SELECT
	    id,
        item_effective_location_at_check_out,
        checkin_service_point_id,
        return_date :: DATE AS return_date,
        to_char(return_date, 'Day') AS day_of_week,
        EXTRACT(hours from return_date) AS hour_of_day,
        item_id,
        item_status
    FROM loans_checkin
),
checkin_actions AS (
    SELECT
        sp.name AS service_point_name,
        sp.discovery_display_name AS service_point_display_name,
        simple_return_dates.return_date AS action_date,
        simple_return_dates.day_of_week,
        simple_return_dates.hour_of_day,
        m.name AS material_type,
        'Checkin' :: VARCHAR AS action_type,
        effloc.name AS effective_location,
	    simple_return_dates.item_status AS item_status,
        count(simple_return_dates.id) AS ct
    FROM simple_return_dates
    LEFT JOIN inventory_locations AS effloc
        ON simple_return_dates.item_effective_location_at_check_out = effloc.id
    LEFT JOIN inventory_items i
        ON simple_return_dates.item_id = i.id
    LEFT JOIN inventory_service_points sp
        ON simple_return_dates.checkin_service_point_id = sp.id
    LEFT JOIN inventory_material_types m
        ON i.material_type_id = m.id
    --remove the WHERE clause below to ignore date range filter
    WHERE
        simple_return_dates.return_date >= (SELECT start_date FROM parameters)
    AND simple_return_dates.return_date <  (SELECT end_date FROM parameters)
    GROUP BY
        sp.name,
        sp.discovery_display_name,
        simple_return_dates.return_date,
        simple_return_dates.day_of_week,
        simple_return_dates.hour_of_day,
        m.name,
        effloc.name,
	    simple_return_dates.item_status
)
SELECT
    service_point_name,
    service_point_display_name,
    action_date,
    day_of_week,
    hour_of_day,
    material_type,
    action_type,
    effective_location,
    item_status,
    ct
FROM checkout_actions
UNION ALL
SELECT
    service_point_name,
    service_point_display_name,
    action_date,
    day_of_week,
    hour_of_day,
    material_type,
    action_type,
    effective_location,
    item_status,
    ct
FROM checkin_actions
ORDER BY
    service_point_name,
    service_point_display_name,
    action_date,
    hour_of_day,
    material_type,
    action_type,
    effective_location,
    item_status
;
