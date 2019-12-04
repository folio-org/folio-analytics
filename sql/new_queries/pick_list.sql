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
        loc.id AS loc_id,
        loc."name" AS loc_name,
        loc.library_id AS library_id,
        libraries."name" AS lib_name,
        loc.campus_id AS campus_id,
        campuses."name" AS camp_name,
        loc.institution_id AS institution_id,
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
instance_formats_extract AS (
    SELECT
        inst.id AS instance_id,
        JSON_ARRAY_ELEMENTS_TEXT(JSON_EXTRACT_PATH_TEXT(inst.data, 'instanceFormatIds') :: JSON) :: VARCHAR AS instance_format_id
    FROM
        instances AS inst
),
identifers_extract AS (
    SELECT
        inst.id AS instance_id,
        JSON_EXTRACT_PATH_TEXT(JSON_ARRAY_ELEMENTS(JSON_EXTRACT_PATH(inst.data, 'identifiers') :: JSON),'identifierTypeId') :: VARCHAR AS type_id,
        JSON_EXTRACT_PATH_TEXT(JSON_ARRAY_ELEMENTS(JSON_EXTRACT_PATH(inst.data, 'identifiers') :: JSON),'value') :: VARCHAR AS value
    FROM
        instances as inst
),
isbn_identifiers AS (
    SELECT instance_id, type_id, value
    FROM
        identifers_extract
        LEFT JOIN identifier_types
            ON identifers_extract.type_id = identifier_types.id
    WHERE
        identifier_types.name = (SELECT isbn_identifier_name FROM parameters)
),
issn_identifiers AS (
    SELECT instance_id, type_id, value
    FROM
        identifers_extract
        LEFT JOIN identifier_types
            ON identifers_extract.type_id = identifier_types.id
    WHERE
        identifier_types.name = (SELECT issn_identifier_name FROM parameters)
),
loans_checkout_lookup AS (
    SELECT
        l.item_id AS item_id,
        l.id AS loan_id
    FROM
        loans AS l
    WHERE    
        l.action = 'checkedout' --uncertain if best method but works and looks right with test data
),
eff_call_no AS (
    SELECT
        i.id AS item_id,
        h.id AS holding_id,
        Coalesce(i.item_level_call_number, h.call_number) :: VARCHAR AS effective_callNumber
    FROM
        items AS i
        LEFT JOIN holdings AS h
            ON i.holdings_record_id = h.id
),
contributor_extract AS (
    SELECT
        inst.id AS instance_id,
        JSON_EXTRACT_PATH_TEXT(JSON_ARRAY_ELEMENTS(JSON_EXTRACT_PATH(inst.data, 'contributors') :: JSON),'name') :: VARCHAR AS name,
        JSON_EXTRACT_PATH_TEXT(JSON_ARRAY_ELEMENTS(JSON_EXTRACT_PATH(inst.data, 'contributors') :: JSON),'primary') :: VARCHAR AS primary
    FROM
        instances AS inst
),
copy_number_extract AS (
    SELECT
        i.id AS item_id,
        JSON_ARRAY_ELEMENTS_TEXT(JSON_EXTRACT_PATH(i.data, 'copyNumbers') :: JSON) :: VARCHAR AS item_copy_number
    FROM
        items AS i
),
publisher_extract AS (
    SELECT
        inst.id AS instance_id,
        JSON_EXTRACT_PATH_TEXT(JSON_ARRAY_ELEMENTS(JSON_EXTRACT_PATH(inst.data, 'publication') :: JSON),'dateOfPublication') :: VARCHAR AS date,
        JSON_EXTRACT_PATH_TEXT(JSON_ARRAY_ELEMENTS(JSON_EXTRACT_PATH(inst.data, 'publication') :: JSON),'publisher') :: VARCHAR AS name
    FROM
        instances AS inst
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
    STRING_AGG(DISTINCT contributor_extract.name, '|') AS contributors,
    --i.volume AS volume, -- no longer in ldp or ldpqdev
    i.enumeration AS enumeration,
    i.chronology AS chronology,
    i.barcode,
    STRING_AGG(DISTINCT copy_number_extract.item_copy_number, '|') AS copy_numbers,
    JSON_EXTRACT_PATH_TEXT(i.data, 'status', 'name') :: VARCHAR AS item_status,
    i.number_of_pieces,
    --i.number_of_missing_pieces, -- no longer in ldp or ldpqdev
    STRING_AGG(DISTINCT isbn_identifiers.value :: VARCHAR, '|') AS isbn_values,
    STRING_AGG(DISTINCT issn_identifiers.value :: VARCHAR, '|') AS issn_values,
    STRING_AGG(DISTINCT publisher_extract.name, '|') AS publisher_name,
    STRING_AGG(DISTINCT publisher_extract.date, '|') AS publisher_date,
    m_types.name AS item_material_type_name,
    inst_types.name AS inst_type_name,
    STRING_AGG(DISTINCT instance_formats.name, '|') AS instance_format_names,
    l_types.name AS item_perm_loan_type,
    COUNT(DISTINCT loans_checkout_lookup.loan_id) AS count_checkout_loans,
    i.id AS item_id,
    h.id AS holding_id,
    inst.id AS instance_id,
    --i.discovery_suppress AS item_supp, -- no longer in ldp or ldpqdev
    --h.discovery_suppress AS hold_supp, -- no longer in ldp or ldpqdev
    inst.discovery_suppress AS inst_supp
FROM
    items AS i
    RIGHT JOIN location_filtering
        ON i.id = location_filtering.i_id
    LEFT JOIN copy_number_extract
        ON i.id = copy_number_extract.item_id
    LEFT JOIN material_types AS m_types
        ON i.material_type_id = m_types.id
    LEFT JOIN loan_types AS l_types
        ON i.permanent_loan_type_id = l_types.id
    LEFT JOIN loans_checkout_lookup
        ON i.id = loans_checkout_lookup.item_id
    LEFT JOIN eff_call_no
        ON i.id = eff_call_no.item_id
    LEFT JOIN holdings AS h
        ON i.holdings_record_id = h.id
    LEFT JOIN instances AS inst
        ON h.instance_id = inst.id
    LEFT JOIN instance_formats_extract
        ON inst.id = instance_formats_extract.instance_id
    LEFT JOIN instance_formats
        ON instance_formats_extract.instance_format_id = instance_formats.id
    LEFT JOIN instance_types AS inst_types
        ON inst.instance_type_id = inst_types.id
    LEFT JOIN contributor_extract
        ON inst.id = contributor_extract.instance_id AND contributor_extract.primary = 'true' --comment out 'AND ...' to get all contributors
    LEFT JOIN isbn_identifiers
        ON inst.id = isbn_identifiers.instance_id
    LEFT JOIN issn_identifiers
        ON inst.id = issn_identifiers.instance_id
    LEFT JOIN publisher_extract
        ON inst.id = publisher_extract.instance_id
GROUP BY
    1,2,3,4,5,6,7, 9,10,11, 13,14, 19,20, 22, 24,25,26,27
;
