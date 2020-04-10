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
        lib."name" AS lib_name,
        loc.campus_id AS campus_id, -- not used
        cmp."name" AS camp_name,
        loc.institution_id AS institution_id, -- not used
        ins."name" AS instut_name
    FROM
        inventory_items AS i
        LEFT JOIN inventory_locations AS loc
            ON i.effective_location_id = loc.id
        LEFT JOIN inventory_libraries AS lib
            ON loc.library_id = lib.id
        LEFT JOIN inventory_campuses AS cmp
            ON loc.campus_id = cmp.id
        LEFT JOIN inventory_institutions AS ins
            ON loc.institution_id = ins.id
    WHERE
        ins."name" = (SELECT institution_filter FROM parameters)
        OR cmp."name" = (SELECT campus_filter FROM parameters)
        OR lib."name" = (SELECT library_filter FROM parameters)
        OR loc."name" = (SELECT location_filter FROM parameters)
),
instance_formats_extract AS (
    SELECT
        inst.id AS instance_id,
        JSON_ARRAY_ELEMENTS_TEXT(JSON_EXTRACT_PATH(inst.data, 'instanceFormatIds')) :: VARCHAR AS instance_format_id
    FROM
        inventory_instances AS inst
),
instance_format_names AS (
    SELECT
        instance_formats_extract.instance_id AS instance_id,
        STRING_AGG(DISTINCT instform.name, '|') AS instance_format_names
    FROM instance_formats_extract
    LEFT JOIN inventory_instance_formats AS instform
        ON instance_formats_extract.instance_format_id = instform.id
    GROUP BY instance_formats_extract.instance_id
),
identifiers_extract AS (
    SELECT
        inst.id AS instance_id,
        JSON_EXTRACT_PATH_TEXT(JSON_ARRAY_ELEMENTS(JSON_EXTRACT_PATH(inst.data, 'identifiers')),'identifierTypeId') :: VARCHAR AS type_id,
        JSON_EXTRACT_PATH_TEXT(JSON_ARRAY_ELEMENTS(JSON_EXTRACT_PATH(inst.data, 'identifiers')),'value') :: VARCHAR AS value
    FROM
        inventory_instances as inst
),
isbn_identifiers AS (
    SELECT instance_id, type_id, value
    FROM
        identifiers_extract
        LEFT JOIN inventory_identifier_types AS idtype
            ON identifiers_extract.type_id = idtype.id
    WHERE
        idtype.name = (SELECT isbn_identifier_name FROM parameters)
),
isbn_agg AS (
    SELECT
        instance_id,
        STRING_AGG(DISTINCT value :: VARCHAR, '|') AS isbn_values
    FROM isbn_identifiers
    GROUP BY instance_id
),
issn_identifiers AS (
    SELECT instance_id, type_id, value
    FROM
        identifiers_extract
        LEFT JOIN inventory_identifier_types AS idtype
            ON identifiers_extract.type_id = idtype.id
    WHERE
        idtype.name = (SELECT issn_identifier_name FROM parameters)
),
issn_agg AS (
    SELECT
        instance_id,
        STRING_AGG(DISTINCT value :: VARCHAR, '|') AS issn_values
    FROM issn_identifiers
    GROUP BY instance_id
),
loans_lookup AS (
    SELECT
        l.item_id AS item_id,
        COUNT(DISTINCT l.id) AS count_loans
    FROM
        circulation_loans AS l
    GROUP BY l.item_id
),
eff_call_no AS (
    SELECT
        i.id AS item_id,
        h.id AS holding_id,
        COALESCE(i.item_level_call_number, h.call_number) :: VARCHAR AS effective_callNumber
    FROM
        inventory_items AS i
        LEFT JOIN inventory_holdings AS h
            ON i.holdings_record_id = h.id
),
contributor_extract AS (
    SELECT
        inst.id AS instance_id,
        JSON_EXTRACT_PATH_TEXT(JSON_ARRAY_ELEMENTS(JSON_EXTRACT_PATH(inst.data, 'contributors')),'name') :: VARCHAR AS name,
        JSON_EXTRACT_PATH_TEXT(JSON_ARRAY_ELEMENTS(JSON_EXTRACT_PATH(inst.data, 'contributors')),'primary') :: VARCHAR AS primary
    FROM
        inventory_instances AS inst
),
contributor_extract_name AS (
    SELECT
        instance_id,
        STRING_AGG(DISTINCT name, '|') AS contributors
    FROM
        contributor_extract
    --comment out WHERE clause to get all contributors
    WHERE contributor_extract.primary = 'true'
    GROUP BY instance_id
),
copy_number_agg AS (
    SELECT
        item_id,
        STRING_AGG(DISTINCT item_copy_number, '|') AS copy_numbers
    FROM (
        SELECT
            i.id AS item_id,
            JSON_ARRAY_ELEMENTS_TEXT(JSON_EXTRACT_PATH(i.data, 'copyNumbers')) :: VARCHAR AS item_copy_number
        FROM
            inventory_items AS i
    ) AS copy_number_extract
    GROUP BY item_id
),
publisher_extract AS (
    SELECT
        inst.id AS instance_id,
        JSON_EXTRACT_PATH_TEXT(JSON_ARRAY_ELEMENTS(JSON_EXTRACT_PATH(inst.data, 'publication')),'dateOfPublication') :: VARCHAR AS date,
        JSON_EXTRACT_PATH_TEXT(JSON_ARRAY_ELEMENTS(JSON_EXTRACT_PATH(inst.data, 'publication')),'publisher') :: VARCHAR AS name
    FROM
        inventory_instances AS inst
),
publisher_names AS (
    SELECT
        instance_id,
        STRING_AGG(DISTINCT name, '|') AS publisher_name
    FROM publisher_extract
    GROUP BY instance_id
),
publisher_dates AS (
    SELECT
        instance_id,
        STRING_AGG(DISTINCT date, '|') AS publisher_date
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
    --i.volume AS volume, -- no longer in ldp or ldpqdev, using alternative below
    JSON_EXTRACT_PATH_TEXT(i.data, 'volume') :: VARCHAR AS volume,
    i.enumeration AS enumeration,
    i.chronology AS chronology,
    i.barcode,
    copy_number_agg.copy_numbers,
    JSON_EXTRACT_PATH_TEXT(i.data, 'status', 'name') :: VARCHAR AS item_status,
    i.number_of_pieces,
    --i.number_of_missing_pieces, -- no longer in ldp or ldpqdev, using alt. below
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
    --i.id AS item_id, -- just an id, take out of results?
    --h.id AS holding_id, -- just an id, take out of results?
    --inst.id AS instance_id, -- just an id, take out of results?
    --i.discovery_suppress AS item_supp, -- no longer in ldp or ldpqdev, using alt. below
    JSON_EXTRACT_PATH_TEXT(i.data, 'discovery_suppress') :: VARCHAR AS item_supp,
    --h.discovery_suppress AS hold_supp, -- no longer in ldp or ldpqdev, using alt. below
    JSON_EXTRACT_PATH_TEXT(h.data, 'discovery_suppress') :: VARCHAR AS hold_supp,
    inst.discovery_suppress AS inst_supp
FROM
    inventory_items AS i
    RIGHT JOIN location_filtering
        ON i.id = location_filtering.i_id
    LEFT JOIN copy_number_agg
        ON i.id = copy_number_agg.item_id
    LEFT JOIN inventory_material_types AS m_types
        ON i.material_type_id = m_types.id
    LEFT JOIN inventory_loan_types AS l_types
        ON i.permanent_loan_type_id = l_types.id
    LEFT JOIN loans_lookup
        ON i.id = loans_lookup.item_id
    LEFT JOIN eff_call_no
        ON i.id = eff_call_no.item_id
    LEFT JOIN inventory_holdings AS h
        ON i.holdings_record_id = h.id
    LEFT JOIN inventory_instances AS inst
        ON h.instance_id = inst.id
    LEFT JOIN instance_format_names
        ON inst.id = instance_format_names.instance_id
    LEFT JOIN inventory_instance_types AS inst_types
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
