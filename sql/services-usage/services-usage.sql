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

WITH parameters AS (
    SELECT
        DATE('2000-01-01') AS start_date,
        DATE('2020-01-01') AS end_date
),

checkout_actions (
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
) AS (
    SELECT
        sp.name,
        sp.discovery_display_name,
        DATE(l.loan_date),
        to_char(l.loan_date, 'Day'),
        date_part('hour',l.loan_date::timestamp),
        m.name,
        'Checkout'::varchar,
        tl.temp_location,
        l.item_status,
        count(l.id)
    FROM (
        SELECT
            id,
            checkout_service_point_id,
            loan_date,
            item_id,
            item_status
        FROM loans
        WHERE
            loan_date BETWEEN (SELECT start_date FROM parameters)
            AND (SELECT end_date FROM parameters)
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

checkin_actions (
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
) AS (
    SELECT
        sp.name,
        sp.discovery_display_name,
        DATE(l.system_return_date),
        to_char(l.system_return_date, 'Day'),
        date_part('hour',l.system_return_date::timestamp),
        m.name,
        'Checkin'::varchar,
        tl.temp_location,
	    l.item_status,
        count(l.id)
    FROM (
        SELECT
            id,
            checkin_service_point_id,
            system_return_date,
            item_id,
            item_status
        FROM loans
        WHERE
            system_return_date BETWEEN (SELECT start_date FROM parameters)
            AND (SELECT end_date FROM parameters)
    ) AS l

    LEFT JOIN temp_loans AS tl
        ON l.id = tl.id

    LEFT JOIN items i
        ON l.item_id = i.id

    LEFT JOIN service_points sp
        ON l.checkin_service_point_id = sp.id

    LEFT JOIN material_types m
        ON i.material_type_id = m.id

    GROUP BY
        sp.name,
        sp.discovery_display_name,
        l.system_return_date,
        m.name,
        tl.temp_location,
	    l.item_status
),

union_of_results AS (
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
FROM union_of_results
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
