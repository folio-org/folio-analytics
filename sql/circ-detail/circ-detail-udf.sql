
-- To call this function, e.g.:
--     SELECT * FROM circ_detail('2017-06-01', '2017-10-01');

CREATE FUNCTION circ_detail(start_date DATE, end_date DATE)
    RETURNS TABLE(location_name TEXT, group_name TEXT, ct BIGINT)
    AS $$
SELECT loc.location_name AS location_name,
       u.group_name AS group_name,
       count(l.loan_key) AS ct
    FROM (
        SELECT loan_key, user_key, location_key
            FROM loans
            WHERE loan_date >= start_date AND loan_date <= end_date
    ) l
        LEFT JOIN locations loc ON l.location_key = loc.location_key
        LEFT JOIN users u ON l.user_key = u.user_key
    GROUP BY loc.location_name, u.group_name
    ORDER BY loc.location_name, u.group_name;
$$
LANGUAGE SQL
IMMUTABLE;

