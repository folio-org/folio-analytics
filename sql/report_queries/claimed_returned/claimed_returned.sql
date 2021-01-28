/*FIELDS INCLUDED IN SAMPLE:
Circulation Loans table
    Effective location at check out
    Item status
    Renewal count
    Action
    Loan date
    Due date
    Return date
    Claimed returned date
Circulation Loan Policies table
    Name
Inventory Items table    
    Barcode
    Item level call number
    Volume
    Enumeration
    Chronology
    Copy number
    Notes description
    Permanent location ID
    Temporary location ID
    Effective location ID
Inventory Holdings table
    Call number
    Shelving title
    Permanent location ID
    Temporary location ID
Inventory Instances table
    Title
    Cataloged date
    Date of publication
Inventory Libraries table
    Name
Inventory Campuses table
    Name
Inventory Institutions table
    Name
Inventory Locations table
    Name
Inventory Material Types table
    Name
User Users table
    First name
    Middle name
    Last name
    Email
    Patron group
User Groups table
    Name
    
FILTERS: loan item status, loan date range, location name (permanent, temporary, effective)

AGGREGATION: total historical loan sum and renewal sum included (not date-range bound)
*/
WITH parameters AS (
    SELECT
        /* Search loans with this status */
        '' :: VARCHAR AS loan_item_status, --Claimed returned
        /* Choose a start and end date for the loans period */
        '2000-01-01' :: DATE AS start_date,
        '2021-01-01' :: DATE AS end_date,
        /* Fill in a location name, OR leave blank for all locations */
        '' :: VARCHAR AS items_permanent_location_filter, --Online, Annex, Main Library
        '' :: VARCHAR AS items_temporary_location_filter, --Online, Annex, Main Library
        '' :: VARCHAR AS items_effective_location_filter, --Online, Annex, Main Library
        '' :: VARCHAR AS institution_filter, -- 'KÃ¸benhavns Universitet','Montoya College'
        '' :: VARCHAR AS campus_filter, -- 'Main Campus','City Campus','Online'
        '' :: VARCHAR AS library_filter -- 'Datalogisk Institut','Adelaide Library'
),
--SUB-QUERIES
subquery_circulation AS (
    SELECT
        l.id AS loan_id,
        l.item_id,
        il.name AS effective_location_at_checkout,
        l.item_status AS loan_item_status,
        l.action AS loan_action,
        l.renewal_count,
        l.loan_date,
        l.due_date AS loan_due_date,
        l.return_date AS loan_return_date,
        JSON_EXTRACT_PATH_TEXT(l.data, 'claimedReturnedDate') :: DATE AS claimed_returned_date,
        lp.name AS loan_policy_name,
        l.user_id,
        l.proxy_user_id
    FROM circulation_loans AS l
    LEFT JOIN circulation_loan_policies AS lp
        ON l.loan_policy_id=lp.id
    LEFT JOIN inventory_locations AS il
        ON JSON_EXTRACT_PATH_TEXT(l.data, 'itemEffectiveLocationIdAtCheckOut') :: VARCHAR = il.id
    WHERE
        loan_date >= (SELECT start_date FROM parameters)
    AND loan_date < (SELECT end_date FROM parameters)
    AND (
        l.item_status = (SELECT loan_item_status FROM parameters)
        OR '' = (SELECT loan_item_status FROM parameters)
    )
    AND (il."name" = (SELECT items_effective_location_filter FROM parameters)
             OR '' = (SELECT items_effective_location_filter FROM parameters))
),
subquery_inventory AS (
    SELECT
        i.id AS item_id,
        iin.id AS instance_id,
        iin.title,
        itpl."name" AS items_perm_location_name,
        ittl."name" AS items_temp_location_name,
        itel."name" AS items_effective_location_name,
        ihpl."name" AS holdings_perm_location_name,
        ihtl."name" AS holdings_temp_location_name,
        inst."name" AS institution_name,
        cmp."name" AS campus_name,
        lib."name" AS library_name,
        i.barcode,
        imt.name AS material_type,
        i.item_level_call_number AS item_call_number,
        ih.call_number AS holdings_call_number,
        JSON_EXTRACT_PATH_TEXT(i.data, 'volume') :: VARCHAR AS volume,
        JSON_EXTRACT_PATH_TEXT(i.data, 'enumeration') :: VARCHAR AS enumeration,
        JSON_EXTRACT_PATH_TEXT(i.data, 'chronology') :: VARCHAR AS chronology,
        JSON_EXTRACT_PATH_TEXT(i.data, 'copyNumber') :: VARCHAR AS copy_number,
        ih.shelving_title,
        JSON_EXTRACT_PATH_TEXT(iin.data, 'catalogedDate') :: DATE AS cataloged_date
    FROM inventory_items AS i
    LEFT JOIN inventory_locations AS itpl
        ON i.permanent_location_id = itpl.id
    LEFT JOIN inventory_locations AS ittl
        ON i.temporary_location_id = ittl.id
    LEFT JOIN inventory_locations AS itel
        ON i.effective_location_id = itel.id
    LEFT JOIN inventory_libraries AS lib
        ON itpl.library_id = lib.id
    LEFT JOIN inventory_campuses AS cmp
        ON itpl.campus_id = cmp.id
    LEFT JOIN inventory_institutions AS inst
        ON itpl.institution_id = inst.id
    LEFT JOIN inventory_holdings AS ih
        ON i.holdings_record_id = ih.id
    LEFT JOIN inventory_instances AS iin
        ON ih.instance_id = iin.id
    LEFT JOIN inventory_material_types AS imt
        ON i.material_type_id = imt.id
    LEFT JOIN inventory_locations AS ihpl
        ON ih.permanent_location_id = ihpl.id
    LEFT JOIN inventory_locations AS ihtl
        ON JSON_EXTRACT_PATH_TEXT(i.data, 'temporaryLocationId') :: VARCHAR = ihtl.id
    WHERE
        (itpl."name" = (SELECT items_permanent_location_filter FROM parameters)
               OR '' = (SELECT items_permanent_location_filter FROM parameters))
    AND (ittl."name" = (SELECT items_temporary_location_filter FROM parameters)
               OR '' = (SELECT items_temporary_location_filter FROM parameters))
    AND (itel."name" = (SELECT items_effective_location_filter FROM parameters)
               OR '' = (SELECT items_effective_location_filter FROM parameters))
    AND (lib."name" = (SELECT library_filter FROM parameters)
               OR '' = (SELECT library_filter FROM parameters))
    AND (cmp."name" = (SELECT campus_filter FROM parameters)
               OR '' = (SELECT campus_filter FROM parameters))
    AND (inst."name" = (SELECT institution_filter FROM parameters)
               OR '' = (SELECT institution_filter FROM parameters))
    AND (ihpl."name" = (SELECT items_permanent_location_filter FROM parameters)
               OR '' = (SELECT items_permanent_location_filter FROM parameters))
    AND (ihtl."name" = (SELECT items_temporary_location_filter FROM parameters)
               OR '' = (SELECT items_temporary_location_filter FROM parameters))
),
subquery_user AS (
    SELECT
        uu.id AS user_id,
        ug.group AS patron_group,
        JSON_EXTRACT_PATH_TEXT(uu.data, 'personal', 'firstName') :: VARCHAR AS first_name,
        JSON_EXTRACT_PATH_TEXT(uu.data, 'personal', 'middleName') :: VARCHAR AS middle_name,
        JSON_EXTRACT_PATH_TEXT(uu.data, 'personal', 'lastName') :: VARCHAR AS last_name,
        JSON_EXTRACT_PATH_TEXT(uu.data, 'personal', 'email' :: VARCHAR) AS email
    FROM
        user_users AS uu
        LEFT JOIN user_groups ug ON uu.patron_group = ug.id
),
subquery_total_loans AS (
    SELECT
        item_id,
        COUNT(item_id) AS loan_count_historical,
        SUM(renewal_count) AS renewal_count_historical
    FROM circulation_loans
    GROUP BY item_id
),
subquery_items_with_notes AS (
    SELECT
        id AS item_id,
        STRING_AGG(notes, ' | ') AS notes
    FROM (
        SELECT
            inventory_items.id,
	    json_extract_path_text(notes.data, 'note') AS notes
        FROM inventory_items
            CROSS JOIN LATERAL json_array_elements(json_extract_path(data, 'notes'))
            WITH ORDINALITY AS notes (data)
        WHERE id IN (SELECT item_id FROM subquery_inventory) -- avoid doing string concats on the entire db
    ) AS notes_set
    GROUP BY id
),
subquery_instances_with_publication_dates AS (
    SELECT
        id AS instance_id,
        STRING_AGG(dop, ' | ') AS dates_of_publication
    FROM (
        SELECT
            inventory_instances.id,
	    json_extract_path_text(publication.data, 'dateOfPublication') AS dop
        FROM inventory_instances
            CROSS JOIN LATERAL json_array_elements(json_extract_path(data, 'publication'))
            WITH ORDINALITY AS publication (data)
        WHERE id IN (SELECT instance_id FROM subquery_inventory) -- avoid doing string concats on the entire db
    ) AS publication_dates_set
    GROUP BY id
)
SELECT
    (SELECT start_date :: VARCHAR FROM parameters) ||
        ' to ' :: VARCHAR ||
        (SELECT end_date :: VARCHAR FROM parameters) AS date_range,
    -- circulation fields
    sc.effective_location_at_checkout,
    sc.loan_item_status,
    sc.loan_action,
    sc.renewal_count,
    stl.loan_count_historical,
    stl.renewal_count_historical,
    sc.loan_date,
    sc.loan_due_date,
    sc.loan_return_date,
    sc.loan_policy_name,
    sc.claimed_returned_date,
    -- inventory fields
    si.title,
    si.items_perm_location_name,
    si.items_temp_location_name,
    si.items_effective_location_name,
    si.holdings_perm_location_name,
    si.holdings_temp_location_name,
    si.institution_name,
    si.campus_name,
    si.library_name,
    si.barcode,
    si.material_type,
    si.item_call_number,
    si.holdings_call_number,
    si.volume,
    si.enumeration,
    si.chronology,
    si.copy_number,
    siwn.notes,
    si.shelving_title,
    siwpd.dates_of_publication,
    si.cataloged_date,
    -- user fields
    su.first_name,
    su.middle_name,
    su.last_name,
    su.email,
    su.patron_group,
    sup.first_name AS proxy_first_name,
    sup.middle_name AS proxy_middle_name,
    sup.last_name AS proxy_last_name,
    sup.email AS proxy_email,
    sup.patron_group AS proxy_patron_group
FROM
    subquery_circulation sc
    INNER JOIN subquery_inventory si ON sc.item_id = si.item_id
    LEFT JOIN subquery_total_loans stl ON si.item_id = stl.item_id
    LEFT JOIN subquery_user su ON sc.user_id = su.user_id
    LEFT JOIN subquery_user sup ON sc.proxy_user_id = sup.user_id
    LEFT JOIN subquery_items_with_notes siwn ON si.item_id = siwn.item_id
    LEFT JOIN subquery_instances_with_publication_dates siwpd ON si.instance_id = siwpd.instance_id;
