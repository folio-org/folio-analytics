SELECT tll.location_name AS location_name,
       g.group_name AS group_name,
       count(l.id) AS count
    FROM (
        SELECT id, user_id
            FROM loans
            WHERE loan_date >= '2017-01-01' AND loan_date <= '2018-12-31'
    ) l
        LEFT JOIN tmp_loans_locations tll ON l.id = tll.loan_id
        LEFT JOIN users u ON l.user_id = u.id
        LEFT JOIN groups g ON u.patron_group_id = g.id
    GROUP BY tll.location_name, g.group_name
    ORDER BY tll.location_name, g.group_name;

