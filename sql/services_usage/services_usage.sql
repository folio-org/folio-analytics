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
        '2020-01-01' :: DATE AS end_date
),
checkout_actions AS (
    SELECT
        sp.name AS service_point_name,
        sp.discovery_display_name AS service_point_display_name,
        l.loan_date :: TIMESTAMP AS action_date,
        to_char(l.loan_date , 'Day') AS day_of_week,
        EXTRACT(hours from l.loan_date ) AS hour_of_day,
        m.name AS material_type,
        'Checkout' :: VARCHAR AS action_type,
        tl.temp_location AS effective_location,
        l.item_status AS item_status,
        count(l.id) AS ct
    FROM (
        SELECT
            id,
            checkout_service_point_id,
            loan_date,
            item_id,
            item_status
        FROM loans
        --remove the WHERE clause below to ignore date range filter
        WHERE
            loan_date >= (SELECT start_date FROM parameters)
        AND loan_date <  (SELECT end_date FROM parameters)
    ) AS l
    LEFT JOIN temp_loans AS tl
        ON l.id = tl.id
    LEFT JOIN items AS i
        ON l.item_id = i.id
    LEFT JOIN service_points AS sp
        ON l.checkout_service_point_id = sp.id
    LEFT JOIN material_types AS m
        ON i.material_type_id = m.id
    GROUP BY
        sp.name,
        sp.discovery_display_name,
        l.loan_date,
        m.name,
        tl.temp_location,
        l.item_status        
),
simple_return_dates AS ( 
    SELECT
	    id,
        checkin_service_point_id,
        COALESCE(system_return_date, return_date :: TIMESTAMPTZ AT TIME ZONE 'UTC' ) AS action_date,
        item_id,
        item_status
    FROM loans
),
checkin_actions AS (
    SELECT
        sp.name AS service_point_name,
        sp.discovery_display_name AS service_point_display_name,
        simple_return_dates.action_date :: TIMESTAMP AS action_date,
        to_char(simple_return_dates.action_date , 'Day') AS day_of_week,
        EXTRACT(hours from simple_return_dates.action_date ) AS hour_of_day,
        m.name AS material_type,
        'Checkin' :: VARCHAR AS action_type,
        tl.temp_location AS effective_location,
	    simple_return_dates.item_status AS item_status,
        count(simple_return_dates.id) AS ct
    FROM simple_return_dates
    LEFT JOIN temp_loans AS tl
        ON simple_return_dates.id = tl.id
    LEFT JOIN items i
        ON simple_return_dates.item_id = i.id
    LEFT JOIN service_points sp
        ON simple_return_dates.checkin_service_point_id = sp.id
    LEFT JOIN material_types m
        ON i.material_type_id = m.id
    --remove the WHERE clause below to ignore date range filter
    WHERE
        simple_return_dates.action_date >= (SELECT start_date FROM parameters)
    AND simple_return_dates.action_date <  (SELECT end_date FROM parameters)
    GROUP BY
        sp.name,
        sp.discovery_display_name,
        simple_return_dates.action_date,
        m.name,
        tl.temp_location,
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
