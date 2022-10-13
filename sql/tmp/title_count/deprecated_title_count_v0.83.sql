/** RM TITLE COUNT

MAIN TABLES WITH NEEDED COLUMNS
- inventory_instances
        - id
        - cataloged_date
        - discovery_suppress
        - instance_type_id
        - mode_of_issuance_id
        - previously_held
        - status_id
        - status_updated_date (not in ldp at this time)
        - data JSON:
                - instanceFormatIds
                - natureOfContentTermIds
                - publication->dateOfPublication
                - statisticalCodeIds

- inventory_holdings
        - id
        - call_number
        - call_number_type_id
        - holdings_type_id
        - instance_id
        - permanent_location_id
        - receipt_status
        - discovery_suppress (not in ldp at this time)
        - data JSON:
                - statisticalCodeIds

Tables for additional fields -- Using IDs from Instances and Holdings to get names

id, name :
- inventory_instance_statuses
- inventory_instance_types
- inventory_modes_of_issuance
- inventory_statistical_codes
- inventory_nature_of_content_terms
- inventory_instance_formats
- inventory_holdings_types
- inventory_call_number_types
- inventory_campuses
- inventory_institutions
- inventory_libraries
- inventory_instance_relationships_types

id, campus_id, institution_id, library_id, discovery_display_name:
- inventory_locations

id, super_instance_id, sub_instance_id:
- inventory_instance_relationships


AGGREGATION:
instance_type, mode_of_issuance, instance_format, instance_statistical_code, instance_nature_of_content, holding_type, callnumber_type, holding_statistical_code, super_relation_type,
sub_relation_type

FILTERS: FOR USERS TO SELECT
cataloged_date, instance_type, instance_format, mode_of_issuance, nature_of_content_terms, holdings_receipt_status, holdings_type, holdings_callnumber,
instance_statistical_code, holdings_statistical_code, permanent_location_name_filter, campus_filter, library_filter, institution_filter

HARDCODED FILTERS
instance_discovery_suppress, instance_statuses (cataloged or batchloaded)


STILL IN PROGRESS:
- dateOfPublication
- add more filters and values for virtual titles as hardcoded filter (instance_type, nature_of_content, inventory_libraries.name)
- holdings_discovery_suppress (not in ldp at this time)
- status_updated_date (not in ldp at this time)
- add more fields as they are avaiable (eg. geographic, language, open access, withdrawn)

*/
WITH parameters AS (

    /** Choose a start and end date if needed */
    SELECT
        '1950-04-01' :: DATE AS cataloged_date_start_date, --ex:2000-01-01
        '2020-05-01' :: DATE AS cataloged_date_end_date, -- ex:2020-01-01

        -- POSSIBLE FORMAT MEASURES -- USE EXACTLY EXACT TERM, CASE SENSITIVE. USE ONE FILTER FOR EACH SPECIFIC ELEMENT NEEDED
        '' :: VARCHAR AS instance_type_filter1, -- select 'Text', 'Performed Music', 'Other' etc. or leave blank for all.
        '' :: VARCHAR AS instance_type_filter2, -- select 'Text', 'Performed Music', 'Other' etc. or leave blank for all.
        '' :: VARCHAR AS instance_type_filter3, -- select 'Text', 'Performed Music', 'Other' etc. or leave blank for all.

        '' :: VARCHAR AS instance_format_filter1,-- select 'audio -- audio disc', 'computer -- other' etc. or leave blank for all. You can use %% as wildcards.
        '' :: VARCHAR AS instance_format_filter2,-- select 'audio -- audio disc', 'computer -- other' etc. or leave blank for all. You can use %% as wildcards.
        '' :: VARCHAR AS instance_format_filter3,-- select 'audio -- audio disc', 'computer -- other' etc. or leave blank for all. You can use %% as wildcards.

        '' :: VARCHAR AS instance_mode_of_issuance_filter, -- select 'integrating resource', 'serial', 'multipart monograph' etc. or leave blank for all.
        '' :: VARCHAR AS nature_of_content_terms_filter, -- select 'textbook', 'journal' etc. or leave blank for all.
        '' :: VARCHAR AS holdings_receipt_status_filter, -- select 'partially received', 'fully received' etc.
        '' :: VARCHAR AS holdings_type_filter, -- select 'Electronic', 'Monograph' etc. or elave blank for all. (This is case sensitive)
        '' :: VARCHAR AS holdings_callnumber_type_filter, -- select .....
        '' :: VARCHAR AS holdings_callnumber_filter, -- use %% as wildcards '1234-abc%%','%%1234-abc','%%1234-abc%%'

        -- STATISTICAL CODES
        '' :: VARCHAR AS instance_statistical_code_filter, -- select 'Active Serial', 'Book, print (books)', 'Book, electronic (ebooks), 'Microfiche' etc. or leave blank for all.
        '' :: VARCHAR AS holdings_statistical_code_filter, -- select 'Active Serial', 'Book, print (books)', 'Book, electronic (ebooks), 'Microfiche' etc. or leave blank for all.

        -- LOCATION
        '' :: VARCHAR AS permanent_location_name_filter, --Online, Annex, Main Library
        '' :: VARCHAR AS campus_filter, -- select 'Main Campus','City Campus','Online' as needed
        '' :: VARCHAR AS library_filter, -- select 'Datalogisk Institut','Adelaide Library' as needed
        '' :: VARCHAR AS institution_filter -- select 'Kï¿½benhavns Universitet','Montoya College' as needed

),

 -- SUBQUERIES/TO MAKE NEEDED TEMPORARY TABLES --

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
        instform.name AS instance_format_name
    FROM instance_formats_extract
    LEFT JOIN inventory_instance_formats AS instform
        ON instance_formats_extract.instance_format_id = instform.id
),
instance_statisticalcodes_extract AS (
    SELECT
        inst.id AS instance_id,
        JSON_ARRAY_ELEMENTS_TEXT(JSON_EXTRACT_PATH(inst.data, 'statisticalCodeIds')) :: VARCHAR AS instance_statisticalcode_id
    FROM
        inventory_instances AS inst
),
instance_statisticalcode_names AS (
    SELECT
        instance_statisticalcodes_extract.instance_id AS instance_id,
        inststatcode.name AS instance_statisticalcode_name
    FROM instance_statisticalcodes_extract
    LEFT JOIN inventory_statistical_codes AS inststatcode
        ON instance_statisticalcodes_extract.instance_statisticalcode_id = inststatcode.id
),
instance_natureofcontentterms_extract AS (
    SELECT
        inst.id AS instance_id,
        JSON_ARRAY_ELEMENTS_TEXT(JSON_EXTRACT_PATH(inst.data, 'natureOfContentTermIds')) :: VARCHAR AS instance_natureofcontent_id
    FROM
        inventory_instances AS inst
),
instance_natureofcontentterms_names AS (
    SELECT
        instance_natureofcontentterms_extract.instance_id AS instance_id,
        instnatcontent.name AS instance_natureofcontentterms_name
    FROM instance_natureofcontentterms_extract
    LEFT JOIN inventory_nature_of_content_terms AS instnatcontent
        ON instance_natureofcontentterms_extract.instance_natureofcontent_id = instnatcontent.id
),
holding_statisticalcodes_extract AS (
    SELECT
        hold.id AS holding_id,
        JSON_ARRAY_ELEMENTS_TEXT(JSON_EXTRACT_PATH(hold.data, 'statisticalCodeIds')) :: VARCHAR AS holding_statisticalcode_id
    FROM
        inventory_holdings AS hold
),
holding_statisticalcode_names AS (
    SELECT
        holding_statisticalcodes_extract.holding_id AS holding_id,
        inststatcode.name AS holding_statisticalcode_name
    FROM holding_statisticalcodes_extract
    LEFT JOIN inventory_statistical_codes AS inststatcode
        ON holding_statisticalcodes_extract.holding_statisticalcode_id = inststatcode.id
)
---------- MAIN QUERY ----------
SELECT
    instance_types.name AS instance type,
    instance_mode_of_issuance.name AS instance_mode_of_issuance,
    instance_format_names.instance_format_name AS instance_format,
    instance_statisticalcode_names.instance_statisticalcode_name AS instance_statistical_code,
    instance_natureofcontentterms_names.instance_natureofcontentterms_name AS instance_nature_of_content,
    holding_type.name AS holding_type,
    call_number_type.name AS callnumber_type,
    holding_statisticalcode_names.holding_statisticalcode_name  AS holding_statistical_code,
    hold.receipt_status AS holdings_receipt_status,
    locations.name AS location,
    inst.previously_held AS previously_held,
    super_relation_type.name AS super_instance,
    sub_relation_type.name AS sub_instance,
    COUNT(DISTINCT inst.id) AS title_count

-- pull the instances related data by joining tables
FROM inventory_instances AS inst
LEFT JOIN inventory_instance_types AS instance_types
    ON inst.instance_type_id = instance_types.id
LEFT JOIN inventory_instance_statuses AS instance_statuses
    ON instance_statuses.id = inst.status_id
LEFT JOIN inventory_modes_of_issuance as instance_mode_of_issuance
    ON instance_mode_of_issuance.id = inst.mode_of_issuance_id
LEFT JOIN instance_format_names
    ON instance_format_names.instance_id = inst.id
LEFT JOIN instance_statisticalcode_names
    ON instance_statisticalcode_names.instance_id = inst.id
LEFT JOIN instance_natureofcontentterms_names
    ON instance_natureofcontentterms_names.instance_id = inst.id

-- add the holdings stuff by joining tables
LEFT JOIN inventory_holdings AS hold
    ON hold.instance_id = inst.id
LEFT JOIN inventory_holdings_types AS holding_type
    ON holding_type.id = hold.holdings_type_id
LEFT JOIN inventory_call_number_types AS call_number_type
    ON call_number_type.id = hold. call_number_type_id
LEFT JOIN holding_statisticalcode_names
    ON holding_statisticalcode_names.holding_id = hold.id

-- get location stuff by joining tables
LEFT JOIN inventory_locations AS locations
    ON hold.permanent_location_id = locations.id
LEFT JOIN inventory_libraries AS library
    ON locations.library_id = library.id
LEFT JOIN inventory_campuses AS campus
    ON library.campus_id = campus.id
LEFT JOIN inventory_institutions AS institution
    ON campus.institution_id = institution.id

-- get instance relations and their types
LEFT JOIN inventory_instance_relationships AS super_relation
    ON super_relation.super_instance_id = inst.id
LEFT JOIN inventory_instance_relationships AS sub_relation
    ON sub_relation.sub_instance_id = inst.id
LEFT JOIN inventory_instance_relationship_types as super_relation_type
    ON super_relation.instance_relationship_type_id = super_relation_type.id
LEFT JOIN inventory_instance_relationship_types as sub_relation_type
    ON sub_relation.instance_relationship_type_id = sub_relation_type.id

WHERE

-- hardcoded filters

    -- if suppressed don't count
    ((NOT inst.discovery_suppress) OR (inst.discovery_suppress ISNULL))
AND
     -- filter all virtual titles (surely need more virtual indicators)
    (instance_format_names.instance_format_name NOT IN  ('computer -- online resource') or  instance_format_names.instance_format_name ISNULL)
AND
    (library.name  NOT IN  ('Online') or  library.name ISNULL)
AND
/*  this is commented out atm because of to few test data
    ((instance_statuses.name = 'Cataloged') OR
    (instance_statuses.name = 'Batchloaded')) -- get only instances with the right status
-- begin to process the set filters
AND
    inst.cataloged_date :: DATE >= (SELECT cataloged_date_start_date FROM parameters)
AND
    inst.cataloged_date :: DATE < (SELECT cataloged_date_end_date FROM parameters)
AND
 */
    (
        (
            instance_types.name IN (
                (SELECT instance_type_filter1 FROM parameters),
                (SELECT instance_type_filter2 FROM parameters),
                (SELECT instance_type_filter3 FROM parameters)
            )
        )
        OR
        (
            (SELECT instance_type_filter1 FROM parameters) = '' AND
            (SELECT instance_type_filter2 FROM parameters) = '' AND
            (SELECT instance_type_filter3 FROM parameters) = ''
        )
    )
AND
    (
        (

        	instance_format_names.instance_format_name LIKE (SELECT instance_format_filter1 FROM parameters) OR
            instance_format_names.instance_format_name LIKE (SELECT instance_format_filter2 FROM parameters) OR
            instance_format_names.instance_format_name LIKE (SELECT instance_format_filter3 FROM parameters)
        )
        OR
        (
            (SELECT instance_format_filter1 FROM parameters) = '' AND
            (SELECT instance_format_filter2 FROM parameters) = '' AND
            (SELECT instance_format_filter3 FROM parameters) = ''
        )
    )
AND
    (instance_mode_of_issuance.name = (SELECT instance_mode_of_issuance_filter FROM parameters) OR
    (SELECT instance_mode_of_issuance_filter FROM parameters) = '')
AND
    (instance_natureofcontentterms_names.instance_natureofcontentterms_name =
       (SELECT nature_of_content_terms_filter FROM parameters) OR
    (SELECT nature_of_content_terms_filter FROM parameters) = '')
AND
    (hold.receipt_status = (SELECT holdings_receipt_status_filter FROM parameters) OR
    (SELECT holdings_receipt_status_filter FROM parameters) = '')
AND
    (holding_type.name = (SELECT holdings_type_filter FROM parameters) OR
    (SELECT holdings_type_filter FROM parameters) = '')
AND
    (call_number_type.name = (SELECT holdings_callnumber_type_filter FROM parameters) OR
    (SELECT holdings_callnumber_type_filter FROM parameters) = '')
AND
    (hold.call_number like (SELECT holdings_callnumber_filter FROM parameters) OR
    (SELECT holdings_callnumber_filter FROM parameters) = '')
AND
    (instance_statisticalcode_names.instance_statisticalcode_name =
        (SELECT instance_statistical_code_filter FROM parameters) OR
    (SELECT instance_statistical_code_filter FROM parameters) = '')
AND
    (holding_statisticalcode_names.holding_statisticalcode_name =
        (SELECT holdings_statistical_code_filter FROM parameters) OR
    (SELECT holdings_statistical_code_filter FROM parameters) = '')
AND
    (campus.name = (SELECT campus_filter FROM parameters) OR
    (SELECT campus_filter FROM parameters) = '')
AND
    (institution.name = (SELECT institution_filter FROM parameters) OR
    (SELECT institution_filter FROM parameters) = '')
AND
    (library.name = (SELECT library_filter FROM parameters) OR
    (SELECT library_filter FROM parameters) = '')
AND
    (locations.name =
        (SELECT permanent_location_name_filter FROM parameters) OR
    (SELECT permanent_location_name_filter FROM parameters) = '')
GROUP BY
    -- you may want to comment any group option to customize your view but keep in mind to have it commented in the SELECT section too
    instance_types.name,
    instance_mode_of_issuance.name,
    instance_format_names.instance_format_name,
    instance_statisticalcode_names.instance_statisticalcode_name,
    instance_natureofcontentterms_names.instance_natureofcontentterms_name,
    holding_type.name,
    call_number_type.name,
    holding_statisticalcode_names.holding_statisticalcode_name,
    hold.receipt_status,
    inst.previously_held,
    locations.name,
    super_relation_type.name,
    sub_relation_type.name
;
