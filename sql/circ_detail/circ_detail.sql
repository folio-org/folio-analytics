/* Change the lines below to adjust the date filter */
WITH parameters AS (
    SELECT
        '2000-01-01' :: DATE AS start_date,
        '2021-01-01' :: DATE AS end_date
)
SELECT
    sp.name AS service_point_name,
    g.group AS group_name,
    count(l.id) AS ct
FROM (
    SELECT
        id,
        user_id,
        checkout_service_point_id,
        patron_group_id_at_checkout
    FROM circulation_loans
    --remove the WHERE clause below to ignore date range filter
    WHERE
        loan_date >= (SELECT start_date FROM parameters)
    AND loan_date <  (SELECT end_date FROM parameters)
) AS l
LEFT JOIN inventory_service_points AS sp
    ON l.checkout_service_point_id = sp.id
LEFT JOIN user_groups AS g
    ON l.patron_group_id_at_checkout = g.id
GROUP BY sp.name, g.group
ORDER BY sp.name, g.group;
