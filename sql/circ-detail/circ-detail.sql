/* Note: start and end dates are hard-coded into this query. */

SELECT
    sp.name AS service_point_name,
    g.group AS group_name,
    count(l.id) AS ct

FROM (
    SELECT
        id,
        user_id,
        checkout_service_point_id
    FROM loans
    /* Change the line below to adjust the date filter */
    WHERE loan_date >= '2017-01-01' AND loan_date <= '2018-12-31'
) AS l

LEFT JOIN service_points AS sp
    ON l.checkout_service_point_id = sp.id

LEFT JOIN users AS u
    ON l.user_id = u.id

LEFT JOIN groups AS g
    ON u.patron_group = g.id

GROUP BY sp.name, g.group
ORDER BY sp.name, g.group;
