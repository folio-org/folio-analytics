SELECT loc.location_name AS location_name,
       u.group_name AS group_name,
       count(l.loan_key) AS ct
    FROM (
        SELECT loan_key, user_key, location_key
            FROM loans
            WHERE loan_date >= '2017-01-01' AND loan_date <= '2018-12-31'
    ) l
        LEFT JOIN locations loc 
              ON l.location_key = loc.location_key
        LEFT JOIN users u
              ON l.user_key = u.user_key
        GROUP BY loc.location_name, u.group_name
        ORDER BY loc.location_name, u.group_name;
