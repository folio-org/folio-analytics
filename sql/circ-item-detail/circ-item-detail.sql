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
    /* change default text for date_range column to match filter below */
    '2017-01-01 to 2018-12-31' AS date_range,
    /* inst.name AS institution_name, */
    ipl.name AS item_perm_location,
    l.loan_date AS loan_date,
    h.shelving_title AS holdings_shelving_title,
    h.call_number AS holdings_call_number,
    i.item_level_call_number AS item_call_number,
    i.barcode AS item_barcode,
    i.enumeration AS item_enumeration,
    /* line below returns an array */
    json_extract_path_text(i.data, 'copyNumbers') AS copy_numbers,
    json_extract_path_text(i.data, 'status', 'name') AS item_status_name,
    m.name AS material_type,
    g.group AS group_name

FROM (
    SELECT
        id,
        user_id,
        item_id,
        loan_date
    FROM loans
    /* Change the line below to adjust the date filter */
    WHERE loan_date >= '2017-01-01' AND loan_date <= '2018-12-31'
) AS l

/* Review this proposed join to items:
   Right now, using left join, so will get loans that connect to
   items without this status. May need to filter by item status elsewhere. */

/*LEFT JOIN (
    SELECT *
    FROM items
    WHERE json_extract_path_text(i.data, 'status', 'name')  = 'Checked out'
) AS i
    ON l.item_id = i.id*/

LEFT JOIN items AS i
    ON l.item_id = i.id

LEFT JOIN users AS u
    ON l.user_id = u.id

LEFT JOIN groups AS g
    ON u.patron_group = g.id

LEFT JOIN holdings AS h
    ON i.holdings_record_id = h.id

LEFT JOIN locations AS ipl
    ON i.permanent_location_id = ipl.id

LEFT JOIN material_types AS m
    ON i.material_type_id = m.id

/*LEFT JOIN institutions AS inst
    ON ipl.institution_id to inst.id*/

/* ORDER BY inst.name, ipl.name, l.loan_date */
ORDER BY ipl.name, l.loan_date
/* THIS CAN BE A LARGE QUERY. REMOVE LIMIT BELOW FOR COMPLETE RESULTS. */
LIMIT 50;
