SELECT loc.location_name AS location_name,
       u.group_name AS group_name,
       count(l.id) AS count
    FROM (
        SELECT id, user_id, location_id
            FROM fact_loans
            WHERE loan_date >= '2017-01-01' AND loan_date <= '2018-12-31'
    ) l
        LEFT JOIN dim_locations loc ON l.location_id = loc.location_id
        LEFT JOIN dim_users u ON l.user_id = u.id
    GROUP BY loc.location_name, u.group_name
    ORDER BY loc.location_name, u.group_name;

