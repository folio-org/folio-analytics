/* FIELDS TO INCLUDE:
    Item Discovery Suppression -- no longer in ldp or ldpqdev
    Holding Discovery Suppression -- no longer in ldp or ldpqdev
    Instance Discovery Suppression
    Instance Format Name
    Instance Type
    Item Material Type Name
    Item Loan Type [based on item permanent_loan_type_id
    Count of Loan Checkouts (ciruclation history)
    Call Number Prefix
    Call No.
    Call No. Suffix
    Contributor/Author (Primary)
    Title
    Index Title
    Volume -- no longer in ldp or ldpqdev
    Enumeration
    Chronology
    Copy Number
    Item-Number of Pieces
    Item-Number of Pieces Missing -- no longer in ldp or ldpqdev
    Item Barcode
    Item Status
    Identifiers ISBN
    Identifiers ISSN
    Publisher
    Date of Publication
    Item Id
    Holding Id
    Instance Id
    
   AGGREGATION:
    Count(Loan Checkouts)
    
   Array Fields:
    Instance Format Names
    Contributor
    Copy Number
    ISBN values
    ISSN values
 */
WITH parameters AS (
    SELECT
        ---- Fill out one, leave others blank to filter location name or code ----
        '' ::VARCHAR AS institution_filter, -- 'KÃ¸benhavns Universitet','Montoya College'
        '' ::VARCHAR AS campus_filter, -- 'Main Campus','City Campus','Online'
        '' ::VARCHAR AS library_filter, -- 'Datalogisk Institut','Adelaide Library'
        'Main Library' ::VARCHAR AS location_filter, -- 'Main Library','Annex','Online'
        --------------------------------------------------------------------------
        ----- Change name if looking for different identifier name displayed
        'ISBN' :: VARCHAR AS isbn_identifier_name, -- 'ISBN','Invalid ISBN'
        'ISSN' :: VARCHAR AS issn_identifier_name -- 'ISSN','Linking ISSN'
),
---------- SUB-QUERIES/TABLES ----------
location_filtering AS (
    SELECT
        i.id AS i_id,
        loc.id AS loc_id, -- not used
        loc."name" AS loc_name,
        loc.library_id AS library_id, -- not used
        libraries."name" AS lib_name,
        loc.campus_id AS campus_id, -- not used
        campuses."name" AS camp_name,
        loc.institution_id AS institution_id, -- not used
        institutions."name" AS instut_name
    FROM
        items AS i
        LEFT JOIN locations AS loc
            ON i.effective_location_id = loc.id
        LEFT JOIN libraries
            ON loc.library_id = libraries.id
        LEFT JOIN campuses
            ON loc.campus_id = campuses.id
        LEFT JOIN institutions
            ON loc.institution_id = institutions.id
    WHERE
        institutions."name" = (SELECT institution_filter FROM parameters)
        OR campuses."name" = (SELECT campus_filter FROM parameters)
        OR libraries."name" = (SELECT library_filter FROM parameters)
        OR loc."name" = (SELECT location_filter FROM parameters)
),
numbers_table AS (
    SELECT 0 AS i
    UNION ALL SELECT 1
    UNION ALL SELECT 2
    UNION ALL SELECT 3
    UNION ALL SELECT 4
    UNION ALL SELECT 5
    UNION ALL SELECT 6
    UNION ALL SELECT 7
    UNION ALL SELECT 8
    UNION ALL SELECT 9
),
instance_formats_objects AS (
    SELECT
        id AS instance_id,
        json_extract_path_text(data, 'instanceFormatIds', true) AS objects
    FROM
        instances
),
instance_formats_expanded AS (
    SELECT
        instance_formats_objects.instance_id AS instance_id,
        json_array_length(instance_formats_objects.objects, true) as number_of_items,
        json_extract_array_element_text(
            instance_formats_objects.objects, 
            numbers_table.i::int, 
            true
        ) AS instance_format_id
    FROM instance_formats_objects
    CROSS JOIN numbers_table
    WHERE numbers_table.i <
        json_array_length(instance_formats_objects.objects, true)
),
instance_format_names AS (
    SELECT 
        instance_id,
        LISTAGG(DISTINCT instance_formats.name, '|' :: VARCHAR) AS instance_format_names
    FROM instance_formats_expanded
    LEFT JOIN instance_formats
        ON instance_formats_expanded.instance_format_id = instance_formats.id
    GROUP BY instance_formats_expanded.instance_id
),
identifiers_objects AS (
    SELECT
        id,
        JSON_EXTRACT_PATH_TEXT(data, 'identifiers', true) AS objects
    FROM
        instances
),
identifiers_expanded AS(
    select 
        identifiers_objects.id,
        json_array_length(identifiers_objects.objects, true) as number_of_items,
        json_extract_array_element_text(
            identifiers_objects.objects, 
            numbers_table.i::int, 
            true
        ) as item
    from identifiers_objects
    cross join numbers_table
    where numbers_table.i <
        json_array_length(identifiers_objects.objects, true)
    ),
identifiers_extract AS (
    SELECT
        identifiers_expanded.id AS instance_id,
        json_extract_path_text(identifiers_expanded.item, 'identifierTypeId')::varchar as type_id,
        json_extract_path_text(identifiers_expanded.item, 'value')::varchar as value
    FROM
        identifiers_expanded
),
isbn_identifiers AS (
    SELECT instance_id, type_id, value
    FROM
        identifiers_extract
        LEFT JOIN identifier_types
            ON identifiers_extract.type_id = identifier_types.id
    WHERE
        identifier_types.name = (SELECT isbn_identifier_name FROM parameters)
),
isbn_agg AS (
    SELECT
        instance_id,
        LISTAGG(DISTINCT value, '|') AS isbn_values
    FROM isbn_identifiers
    GROUP BY instance_id
),
issn_identifiers AS (
    SELECT instance_id, type_id, value
    FROM
        identifiers_extract
        LEFT JOIN identifier_types
            ON identifiers_extract.type_id = identifier_types.id
    WHERE
        identifier_types.name = (SELECT issn_identifier_name FROM parameters)
),
issn_agg AS (
    SELECT
        instance_id,
        LISTAGG(DISTINCT value, '|') AS issn_values
    FROM issn_identifiers
    GROUP BY instance_id
),
loans_lookup AS (
    SELECT
        l.item_id AS item_id,
        COUNT(DISTINCT l.id) AS count_loans
    FROM
        loans AS l
    GROUP BY l.item_id
),
eff_call_no AS (
    SELECT
        i.id AS item_id,
        h.id AS holding_id,
        COALESCE(i.item_level_call_number, h.call_number) :: VARCHAR AS effective_callNumber
    FROM
        items AS i
        LEFT JOIN holdings AS h
            ON i.holdings_record_id = h.id
),
contributor_objects AS (
    SELECT
        id,
        JSON_EXTRACT_PATH_TEXT(data, 'contributors', true) AS objects
    FROM
        instances
),
contributor_expanded AS(
    select 
        contributor_objects.id,
        json_array_length(contributor_objects.objects, true) as number_of_items,
        json_extract_array_element_text(
            contributor_objects.objects, 
            numbers_table.i::int, 
            true
        ) as item
    from contributor_objects
    cross join numbers_table
    where numbers_table.i <
        json_array_length(contributor_objects.objects, true)
    ),
contributor_extract AS (
    SELECT
        contributor_expanded.id AS instance_id,
        json_extract_path_text(contributor_expanded.item, 'name')::varchar as name,
        json_extract_path_text(contributor_expanded.item, 'primary')::varchar as primary
    FROM
        contributor_expanded
),
contributor_extract_name AS (
    SELECT
        instance_id,
        LISTAGG(DISTINCT name, '|') AS contributors
    FROM
        contributor_extract
    --comment out WHERE clause to get all contributors
    WHERE contributor_extract.primary = 'true'
    GROUP BY instance_id
),
copy_num_objects AS (
    SELECT
        id,
        JSON_EXTRACT_PATH_TEXT(data, 'copyNumbers', true) AS objects
    FROM
        items
),
copy_num_expanded AS(
    select 
        copy_num_objects.id,
        json_array_length(copy_num_objects.objects, true) as number_of_items,
        json_extract_array_element_text(
            copy_num_objects.objects, 
            numbers_table.i::int, 
            true
        ) as item
    from copy_num_objects
    cross join numbers_table
    where numbers_table.i <
        json_array_length(copy_num_objects.objects, true)
    ),
copy_number_agg AS (
    SELECT
        copy_num_expanded.id AS item_id,
        LISTAGG(DISTINCT item, '|') AS copy_numbers
    FROM copy_num_expanded
    GROUP BY item_id
),
publisher_objects AS (
    SELECT
        id,
        JSON_EXTRACT_PATH_TEXT(data, 'publication', true) AS objects
    FROM
        instances
),
publisher_expanded AS(
    select 
        publisher_objects.id,
        json_array_length(publisher_objects.objects, true) as number_of_items,
        json_extract_array_element_text(
            publisher_objects.objects, 
            numbers_table.i::int, 
            true
        ) as item
    from publisher_objects
    cross join numbers_table
    where numbers_table.i <
        json_array_length(publisher_objects.objects, true)
    ),
publisher_extract AS (
    SELECT
        publisher_expanded.id AS instance_id,
        json_extract_path_text(publisher_expanded.item, 'dateOfPublication')::varchar as date,
        json_extract_path_text(publisher_expanded.item, 'publisher')::varchar as name
    FROM
        publisher_expanded
),
publisher_names AS (
    SELECT
        instance_id,
        LISTAGG(DISTINCT name, '|') AS publisher_name
    FROM publisher_extract
    GROUP BY instance_id
),
publisher_dates AS (
    SELECT
        instance_id,
        LISTAGG(DISTINCT date, '|') AS publisher_date
    FROM publisher_extract
    GROUP BY instance_id
)
---------- MAIN QUERY ----------
SELECT
    location_filtering.loc_name AS loc_name,
    location_filtering.lib_name AS lib_name,
    location_filtering.camp_name AS camp_name,
    location_filtering.instut_name AS instut_name,
    eff_call_no.effective_callNumber AS eff_call_no,
    inst.title AS title,
    inst.index_title AS index_title,
    contributor_extract_name.contributors,
    --i.volume AS volume, -- no longer in ldp or ldpqdev
    JSON_EXTRACT_PATH_TEXT(i.data, 'volume') :: VARCHAR AS volume,
    i.enumeration AS enumeration,
    i.chronology AS chronology,
    i.barcode,
    copy_number_agg.copy_numbers,
    JSON_EXTRACT_PATH_TEXT(i.data, 'status', 'name') :: VARCHAR AS item_status,
    i.number_of_pieces,
    --i.number_of_missing_pieces, -- no longer in ldp or ldpqdev
    JSON_EXTRACT_PATH_TEXT(i.data, 'number_of_missing_pieces') :: VARCHAR AS number_of_missing_pieces,
    isbn_agg.isbn_values,
    issn_agg.issn_values,
    publisher_names.publisher_name,
    publisher_dates.publisher_date,
    m_types.name AS item_material_type_name,
    inst_types.name AS inst_type_name,
    instance_format_names.instance_format_names,
    l_types.name AS item_perm_loan_type,
    loans_lookup.count_loans AS count_loans,
    i.id AS item_id, -- take out of results?
    h.id AS holding_id, -- take out of results?
    inst.id AS instance_id, -- take out of results?
    --i.discovery_suppress AS item_supp, -- no longer in ldp or ldpqdev
    JSON_EXTRACT_PATH_TEXT(i.data, 'discovery_suppress') :: VARCHAR AS item_supp,
    --h.discovery_suppress AS hold_supp, -- no longer in ldp or ldpqdev
    JSON_EXTRACT_PATH_TEXT(h.data, 'discovery_suppress') :: VARCHAR AS hold_supp,
    inst.discovery_suppress AS inst_supp
FROM
    items AS i
    RIGHT JOIN location_filtering
        ON i.id = location_filtering.i_id
    LEFT JOIN copy_number_agg
        ON i.id = copy_number_agg.item_id
    LEFT JOIN material_types AS m_types
        ON i.material_type_id = m_types.id
    LEFT JOIN loan_types AS l_types
        ON i.permanent_loan_type_id = l_types.id
    LEFT JOIN loans_lookup
        ON i.id = loans_lookup.item_id
    LEFT JOIN eff_call_no
        ON i.id = eff_call_no.item_id
    LEFT JOIN holdings AS h
        ON i.holdings_record_id = h.id
    LEFT JOIN instances AS inst
        ON h.instance_id = inst.id
    LEFT JOIN instance_format_names
        ON inst.id = instance_format_names.instance_id
    LEFT JOIN instance_types AS inst_types
        ON inst.instance_type_id = inst_types.id
    LEFT JOIN contributor_extract_name
        ON inst.id = contributor_extract_name.instance_id
    LEFT JOIN isbn_agg
        ON inst.id = isbn_agg.instance_id
    LEFT JOIN issn_agg
        ON inst.id = issn_agg.instance_id
    LEFT JOIN publisher_names
        ON inst.id = publisher_names.instance_id
    LEFT JOIN publisher_dates
        ON inst.id = publisher_dates.instance_id
;
