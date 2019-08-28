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

/* still needed:
    loans:returnDate
    loans:systemReturnDate
    loans:checkinServicePointId
    effective locations
    record-effective and historical data to do comparison between current state
      and state before checkout

    would like loan_date to include times throughout the day
*/

/* TO DO:

Need to wait for "record-effective" and multiple states of each item before can
do the item status and effective location calculations

also need effective location

for item status before action, will have to grab all item records (just for
items in selected loans??), calculate previous status and previous effective
location for each row where status is checked out, then join back to loans using
date somehow? loan links to item but not to a specific item state, so need to
find a record-effective date on a status = checked out that is close to the loan
date (or system_return_date close to status != checked out)???

json_extract_path_text(i.data, 'status', 'name') AS item_status_name

*/

WITH parameters AS (
    SELECT
        TEXT('2000-01-01') AS start_date,
        TEXT('2020-01-01') AS end_date
),

checkout_actions (
    service_point_name,
    service_point_display_name,
    action_date,
    day_of_week,
    hour_of_day,
    material_type,
    action_type,
    ct
) AS (
    SELECT
        sp.name,
        sp.discovery_display_name,
        DATE(l.loan_date),
        to_char(l.loan_date, 'Day'),
        date_part('hour',l.loan_date),
        m.name,
        'Checkout',
        count(l.id)
    FROM (
        SELECT
            id,
            checkout_service_point_id,
            loan_date,
            item_id
        FROM loans
        WHERE
            loan_date BETWEEN (SELECT DATE(start_date) FROM parameters)
            AND (SELECT DATE(end_date) FROM parameters)
    ) AS l

    LEFT JOIN items AS i
        ON l.item_id = i.id

    LEFT JOIN service_points AS sp
        ON l.checkout_service_point_id = sp.id

    LEFT JOIN material_types AS m
        ON i.material_type_id = m.id

    GROUP BY sp.name, sp.discovery_display_name, l.loan_date, m.name
),

checkin_actions (
    service_point_name,
    service_point_display_name,
    action_date,
    day_of_week,
    hour_of_day,
    material_type,
    action_type,
    ct
) AS (
    SELECT
        sp.name,
        sp.discovery_display_name,
        /*  convert all due_date to system_return_date*/
        DATE(l.due_date),
        to_char(l.due_date, 'Day'),
        date_part('hour',l.due_date),
        m.name,
        'Checkin',
        count(l.id)
    FROM (
        /* SELECT
            id,
            checkin_service_point_id,
            system_return_date,
            item_id */
        SELECT
            id,
            checkout_service_point_id,
            due_date,
            item_id
        FROM loans
        /* WHERE system_return_date >= '2017-01-01'
        AND system_return_date <= '2018-12-31'*/
        WHERE
            due_date BETWEEN (SELECT DATE(start_date) FROM parameters)
            AND (SELECT DATE(end_date) FROM parameters)
       ) AS l

    LEFT JOIN items i
        ON l.item_id = i.id

    LEFT JOIN service_points sp
        /* ON l.checkin_service_point_id = sp.id*/
        ON l.checkout_service_point_id = sp.id

    LEFT JOIN material_types m
        ON i.material_type_id = m.id

    /*GROUP BY
        sp.name,
        sp.discovery_display_name,
        l.system_return_date,
        m.name*/
    GROUP BY
        sp.name,
        sp.discovery_display_name,
        l.due_date,
        m.name
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
    ct
FROM union_of_results
ORDER BY
    service_point_name,
    service_point_display_name,
    action_date,
    hour_of_day,
    material_type,
    action_type;
