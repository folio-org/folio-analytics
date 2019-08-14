/* FIELDS INCLUDED IN SAMPLE:
    date range (filter?)
    owning library
    charge date
    item barcode
    title
    holdings location
    display call no
    item enum
    copy number
    patron group name

EXTRA FIELDS MENTIONED IN PROTOTYPE DESCRIPTION
    loan type
    material type
    reserves

Note: no aggregation
FILTERS: loan date, item status

*/

SELECT
       /* text column showing date range? */
       /* inst.name AS institution_name, */
       ipl.name AS item_perm_location,
       l.loan_date AS loan_date,
       h.shelving_title AS holdings_shelving_title,
       h.call_number AS holdings_call_number,
       i.item_level_call_number AS item_call_number,
       i.barcode AS item_barcode,
       i.enumeration AS item_enumeration,
       i.data->>'copyNumbers' AS copy_numbers, /* note that this returns an array */
       i.data->'status'->>'name' AS item_status_name,
       m.name AS material_type,
       g.group AS group_name
       FROM (
           SELECT id, user_id, item_id, loan_date
               FROM loans
               WHERE loan_date >= '2017-01-01' AND loan_date <= '2018-12-31'
       ) l
       /*LEFT JOIN (SELECT * from items WHERE i.data->'status'->>'name' = 'Checked out') i
          ON l.item_id = i.id*/
       LEFT JOIN items i
          ON l.item_id = i.id
       LEFT JOIN users u
          ON l.user_id = u.id
       LEFT JOIN groups g
          ON u.patron_group = g.id
       LEFT JOIN holdings h
          ON i.holdings_record_id = h.id
       LEFT JOIN locations ipl
          ON i.permanent_location_id = ipl.id
       LEFT JOIN material_types m
          ON i.material_type_id = m.id
       /*LEFT JOIN institutions inst
          ON ipl.institution_id to inst.id*/
    /* ORDER BY inst.name, ipl.name, l.loan_date */
    ORDER BY ipl.name, l.loan_date
    /* THIS CAN BE A LARGE QUERY; ADJUST LIMIT AS NEEDED OR ADD ADDITIONAL FILTERS */
    LIMIT 50
;
