WITH v AS (
    SELECT '2017-01-01 - 2018-12-31'::text AS checkout_date_range,
           *,
           COALESCE(affiliate_a, 0)
               + COALESCE(affiliate_b, 0)
               + COALESCE(affiliate_c, 0)
               + COALESCE(affiliate_d, 0)
               + COALESCE(alumni, 0)
               + COALESCE(faculty, 0)
               + COALESCE(freshman, 0)
	       + COALESCE(graduate, 0)
	       + COALESCE(junior, 0)
	       + COALESCE(senior, 0)
	       + COALESCE(sophomore, 0)
	       + COALESCE(staff, 0)
	       -- + COALESCE(undergrad, 0)
	       AS total_for_library
        FROM crosstab(
            'SELECT tll.location_name, g.group_name, count(l.id) AS ct
    	         FROM (
                     SELECT *
    	                 FROM loans
                         WHERE loan_date >= ''2017-01-01'' AND
    	                     loan_date <= ''2018-12-31''
                 ) l
                     LEFT JOIN tmp_loans_locations tll ON l.id = tll.loan_id
                     LEFT JOIN users u ON l.user_id = u.id
                     LEFT JOIN groups g ON u.patron_group_id = g.id
                 GROUP BY tll.location_name, g.group_name
                 ORDER BY 1, 2',
            'SELECT DISTINCT group_name
    	         FROM groups
    	         ORDER BY 1'
             ) AS ct ("library" TEXT,
	              "affiliate_a" BIGINT,
	              "affiliate_b" BIGINT,
	              "affiliate_c" BIGINT,
	              "affiliate_d" BIGINT,
	              "alumni" BIGINT,
	              "faculty" BIGINT,
	              "freshman" BIGINT,
		      "graduate" BIGINT,
		      "junior" BIGINT,
		      "senior" BIGINT,
		      "sophomore" BIGINT,
                      "staff" BIGINT
		      -- "undergrad" BIGINT
	          )
)
SELECT *
    FROM v
UNION ALL
SELECT '',
       'total_for_patron_group',
       sum(affiliate_a),
       sum(affiliate_b),
       sum(affiliate_c),
       sum(affiliate_d),
       sum(alumni),
       sum(faculty),
       sum(freshman),
       sum(graduate),
       sum(junior),
       sum(senior),
       sum(sophomore),
       sum(staff),
       sum(total_for_library)
       -- sum(undergrad),
    FROM v;

