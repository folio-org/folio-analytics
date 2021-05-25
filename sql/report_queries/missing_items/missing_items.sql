/* Change the lines below to adjust the date and location filters */
WITH parameters AS (
    SELECT
        '2000-01-01'::date AS start_date,
        '2022-01-01'::date AS end_date,
        'Missing'::varchar AS item_status_filter, --  Should be 'Missing'
              ---- Fill out one location or service point filter, leave others blank ----
        ''::varchar AS item_permanent_location_filter, -- 'Main Library'
        ''::varchar AS item_temporary_location_filter, -- 'Annex'
        ''::varchar AS holdings_permanent_location_filter, -- 'Main Library'
        ''::varchar AS holdings_temporary_location_filter, -- 'Main Library'
        ''::varchar AS effective_location_filter -- 'Main Library'
),
---------- SUB-QUERIES/TABLES ----------
item_subset AS (
    SELECT 
        item_id,
        holdings_record_id,
        status_name AS item_status,
        status_date::timestamp AS item_status_date,
        barcode,
        call_number,
        enumeration,
        chronology,
        copy_number,
        volume
    FROM 
        folio_reporting.item_ext AS it
    WHERE
        status_date::timestamp >= (SELECT start_date FROM parameters)
    AND status_date::timestamp < (SELECT end_date FROM parameters)
    AND (status_name = (SELECT item_status_filter FROM parameters)
        OR (SELECT item_status_filter FROM parameters) = '')
),
ranked_loans AS (
    SELECT
        cl.item_id,
        cl.id AS loan_id,
        cl.return_date AS loan_return_date,
        cl.item_status,
        rank() OVER (PARTITION BY cl.item_id ORDER BY cl.return_date DESC) AS return_date_ranked
    FROM
        public.circulation_loans AS cl
        RIGHT JOIN item_subset AS its ON cl.item_id = its.item_id
),
latest_loan AS (
    SELECT
        item_id,
        loan_id,
        item_status,
        loan_return_date 
    FROM
        ranked_loans
    WHERE
        ranked_loans.return_date_ranked = 1
),
item_notes_list AS (
    SELECT
        itn.item_id,
        string_agg(DISTINCT itn.note, '|'::text) AS notes_list
    FROM
        folio_reporting.item_notes AS itn
        RIGHT JOIN item_subset AS its ON itn.item_id = its.item_id
    GROUP BY
        itn.item_id
),
instance_subset AS (
    SELECT 
        ie.instance_id 
    FROM 
    item_subset AS its
    LEFT JOIN folio_reporting.holdings_ext AS he ON its.holdings_record_id = he.holdings_id
    LEFT JOIN folio_reporting.instance_ext AS ie ON he.instance_id = ie.instance_id
),
publication_dates_list AS (
    SELECT
        ip.instance_id,
        string_agg(DISTINCT date_of_publication, '|'::text) AS publication_dates_list
    FROM
        folio_reporting.instance_publication AS ip
        RIGHT JOIN instance_subset AS ins ON ip.instance_id = ins.instance_id
    GROUP BY
        ip.instance_id
)
    ---------- MAIN QUERY ----------
SELECT
    (SELECT start_date::varchar FROM parameters) || 
        ' to '::varchar || 
        (SELECT end_date::varchar FROM parameters) AS date_range,
    its.item_id,
    ie.title,
    he.shelving_title,
    its.item_status,
    its.item_status_date,
    ll.loan_return_date AS last_loan_return_date,
    li.checkout_service_point_name,
    li.checkin_service_point_name,
    its.barcode,
    its.call_number,
    its.enumeration,
    its.chronology,
    its.copy_number,
    its.volume,
    he.permanent_location_name AS holdings_permanent_location_name,
    he.temporary_location_name AS holdings_temporary_location_name,
    li.current_item_permanent_location_name,
    li.current_item_temporary_location_name,
    li.current_item_effective_location_name,
    ie.cataloged_date,
    pd.publication_dates_list,
    nl.notes_list,
    li.material_type_name,
    lc.num_loans,
    lc.num_renewals
FROM
    item_subset AS its -- how TO LIMIT this TO subset? OR expand subset WITH COLUMNS?
	LEFT JOIN folio_reporting.loans_items AS li ON its.item_id=li.item_id 
    INNER JOIN latest_loan AS ll ON li.loan_id = ll.loan_id
    LEFT JOIN item_notes_list AS nl ON li.item_id = nl.item_id
    LEFT JOIN folio_reporting.holdings_ext AS he ON li.holdings_record_id = he.holdings_id
    LEFT JOIN folio_reporting.instance_ext AS ie ON he.instance_id = ie.instance_id
    LEFT JOIN folio_reporting.instance_publication AS ip ON ie.instance_id = ip.instance_id
    LEFT JOIN publication_dates_list AS pd ON ie.instance_id = pd.instance_id
    LEFT JOIN folio_reporting.loans_renewal_count AS lc ON li.item_id = lc.item_id
WHERE (li.current_item_permanent_location_name = 
        (SELECT item_permanent_location_filter FROM parameters)
        OR (SELECT item_permanent_location_filter FROM parameters) = '')
    AND (li.current_item_temporary_location_name = 
        (SELECT item_temporary_location_filter FROM parameters)
        OR (SELECT item_temporary_location_filter FROM parameters) = '')
    AND (he.permanent_location_name = 
        (SELECT holdings_permanent_location_filter FROM parameters)
        OR (SELECT holdings_permanent_location_filter FROM parameters) = '')
    AND (he.temporary_location_name = 
        (SELECT holdings_temporary_location_filter FROM parameters)
        OR (SELECT holdings_temporary_location_filter FROM parameters) = '')
    AND (current_item_effective_location_name = 
        (SELECT effective_location_filter FROM parameters)
        OR (SELECT effective_location_filter FROM parameters) = '')
;
