create extension if not exists tablefunc;

create temporary view v as
select '2017-01-01 - 2018-12-31' as checkout_date_range,
       *,
       coalesce(faculty, 0) + coalesce(graduate, 0) + coalesce(staff, 0) +
           coalesce(undergrad, 0) as total_for_library
    from crosstab(
    'select li.location_name, g.groupname, count(l.id) as ct from (
        select * from loans
            where loan_date >= ''2017-01-01'' and loan_date <= ''2018-12-31''
        ) l
            left join loans_item li
                on l.id = li.loan_id
            left join users u
                on l.user_id = u.id
            left join groups g
                on u.patron_group_id = g.id
        group by li.location_name, g.groupname
        order by 1, 2',
    'select distinct(groupname) from groups order by 1'
    ) as ct ("library" text, "faculty" bigint, "graduate" bigint,
             "staff" bigint, "undergrad" bigint)
;

select *
    from v
union all
select '',
       'total_for_patron_group',
       sum(faculty),
       sum(graduate),
       sum(staff),
       sum(undergrad),
       sum(total_for_library)
    from v
;

