-- This query counts virtual instance titles. You can use various filters to create statistics.

WITH parameters AS (
    SELECT
        '1950-04-01'::DATE AS cataloged_date_start_date, --ex:2000-01-01
        '2050-01-01'::DATE AS cataloged_date_end_date, -- ex:2020-01-01
        -- POSSIBLE FORMAT MEASURES -- USE EXACTLY EXACT TERM, CASE SENSITIVE. USE ONE FILTER FOR EACH SPECIFIC ELEMENT NEEDED
        ''::VARCHAR AS instance_type_filter1, -- select 'Text', 'Performed Music', 'Other' etc. or leave blank for all.
        ''::VARCHAR AS instance_type_filter2, -- select 'Text', 'Performed Music', 'Other' etc. or leave blank for all.
        ''::VARCHAR AS instance_type_filter3, -- select 'Text', 'Performed Music', 'Other' etc. or leave blank for all.
        ''::VARCHAR AS instance_status_filter1, -- select 'Cataloged', 'Batchloaded' etc. or leave blank for all.
        ''::VARCHAR AS instance_status_filter2, -- select 'Cataloged', 'Batchloaded' etc. or leave blank for all.
        ''::VARCHAR AS instance_format_filter1, -- select 'audio -- audio disc', 'computer -- other' etc. or leave blank for all. You can use %% as wildcards.
        ''::VARCHAR AS instance_format_filter2, -- select 'audio -- audio disc', 'computer -- other' etc. or leave blank for all. You can use %% as wildcards.
        ''::VARCHAR AS instance_format_filter3, -- select 'audio -- audio disc', 'computer -- other' etc. or leave blank for all. You can use %% as wildcards.
        ''::VARCHAR AS instance_language_filter, -- select 'eng', 'ger' etc. or leave blank for all.
        ''::VARCHAR AS instance_mode_of_issuance_filter, -- select 'integrating resource', 'serial', 'multipart monograph' etc. or leave blank for all.
        ''::VARCHAR AS nature_of_content_terms_filter, -- select 'textbook', 'journal' etc. or leave blank for all.
        ''::VARCHAR AS holdings_receipt_status_filter, -- select 'partially received', 'fully received' etc. or leave blank for all.
        ''::VARCHAR AS holdings_type_filter, -- select 'Electronic', 'Monograph' etc. or elave blank for all. (This is case sensitive)
        ''::VARCHAR AS holdings_callnumber_type_filter, -- select 'LC Modified', 'Title', 'Shelved separately' or leave blank for all.
        ''::VARCHAR AS holdings_callnumber_filter, -- use %% as wildcards '1234-abc%%','%%1234-abc','%%1234-abc%%'
        ''::VARCHAR AS holdings_acquisition_method_filter, -- select 'Purchase', 'Approval', 'Gifts' or leave blank for all.
        -- STATISTICAL CODES
        ''::VARCHAR AS instance_statistical_code_filter, -- select 'Active Serial', 'Book, print (books)', 'Book, electronic (ebooks), 'Microfiche' etc. or leave blank for all.
        ''::VARCHAR AS holdings_statistical_code_filter, -- select 'Active Serial', 'Book, print (books)', 'Book, electronic (ebooks), 'Microfiche' etc. or leave blank for all.
        ''::VARCHAR AS instance_statistical_code_type_filter, -- select 'ARL (Collection stats)', 'DISC (Discovery)' or leave blank for all.
        -- LOCATION
        ''::VARCHAR AS permanent_location_name_filter, -- Online, Annex, Main Library
        ''::VARCHAR AS campus_filter, -- select 'Main Campus','City Campus','Online' as needed
        ''::VARCHAR AS library_filter, -- select 'Datalogisk Institut','Adelaide Library' as needed
        ''::VARCHAR AS institution_filter -- select 'Kobenhavns Universitet','Montoya College' as needed
)
SELECT
    instance_ext.type_id,
    instance_ext.type_name,
    instance_ext.mode_of_issuance_id,
    instance_ext.mode_of_issuance_name,
    instance_formats.instance_format_id,
    instance_formats.instance_format_code,
    instance_formats.instance_format_name,
    instance_languages.instance_language AS first_language,
    instance_statistical_codes.statistical_code_id AS instance_statistical_code_id,
    instance_statistical_codes.statistical_code AS instance_statistical_code,
    instance_statistical_codes.statistical_code_name AS instance_statistical_code_name,
    instance_nature_content.nature_of_content_term_id AS nature_of_content_id,
    instance_nature_content.nature_of_content_term_id AS nature_of_content_code,
    instance_nature_content.nature_of_content_term_name AS nature_of_content_name,
    holdings_ext.type_id AS holdings_type_id,
    holdings_ext.type_name AS holdings_type_name,
    holdings_ext.call_number_type_id AS holdings_callnumber_type_id,
    holdings_ext.call_number_type_name AS holdings_callnumber_type_name,
    holdings_statistical_codes.statistical_code_id AS holdings_statistical_code_id,
    holdings_statistical_codes.statistical_code AS holdings_statistical_code,
    holdings_statistical_codes.statistical_code_name AS holdings_statistical_code_name,
    holdings_ext.receipt_status AS holdings_receipt_status,
    locations_libraries.location_name,
    instance_ext.previously_held,
    super_relation.relationship_type_id AS instance_super_relation_relationship_type_id,
    super_relation.relationship_type_name AS instance_super_relation_relationship_type_name,
    sub_relation.relationship_type_id AS instance_sub_relation_relationship_type_id,
    sub_relation.relationship_type_name AS instance_sub_relation_relationship_type_name,
    COUNT(DISTINCT instance_ext.instance_id) AS title_count
FROM
    folio_derived.instance_ext
    LEFT JOIN folio_derived.instance_statistical_codes                   ON instance_statistical_codes.instance_id        = instance_ext.instance_id
    LEFT JOIN folio_derived.instance_nature_content                      ON instance_nature_content.instance_id           = instance_ext.instance_id
    LEFT JOIN folio_derived.instance_formats                             ON instance_formats.instance_id                  = instance_ext.instance_id 
    LEFT JOIN folio_derived.instance_relationships_ext AS super_relation ON super_relation.relationship_super_instance_id = instance_ext.instance_id
    LEFT JOIN folio_derived.instance_relationships_ext AS sub_relation   ON sub_relation.relationship_sub_instance_id     = instance_ext.instance_id
    LEFT JOIN folio_derived.holdings_ext                                 ON holdings_ext.instance_id                      = instance_ext.instance_id 
    LEFT JOIN folio_derived.holdings_statistical_codes                   ON holdings_statistical_codes.holdings_id        = holdings_ext.holdings_id
    LEFT JOIN folio_derived.locations_libraries                          ON locations_libraries.location_id               = holdings_ext.permanent_location_id
    LEFT JOIN folio_derived.instance_languages                           ON instance_languages.instance_id                = instance_ext.instance_id 
                                                                        AND instance_languages.language_ordinality        = 1
WHERE
    /*
     * hardcoded filters
     */
    -- filter all virtual titles (update values as needed)
    (instance_formats.instance_format_name IN ('computer -- online resource') OR locations_libraries.library_name IN ('Online'))
    -- if suppressed don't count (instance level)
    AND COALESCE(instance_ext.discovery_suppress, 'false')::boolean != true
    -- if suppressed don't count (holdings level)
    AND COALESCE(holdings_ext.discovery_suppress, 'false')::boolean != true    
    /*
     * individual filters from above
     */
    -- date range start cataloged date - cataloged date can be NULL
    AND (instance_ext.cataloged_date :: DATE >= (SELECT cataloged_date_start_date FROM parameters) OR instance_ext.cataloged_date :: DATE IS NULL)
    -- date range end cataloged date - cataloged date can be NULL
    AND (instance_ext.cataloged_date :: DATE < (SELECT cataloged_date_end_date FROM parameters) OR instance_ext.cataloged_date :: DATE IS NULL)
    -- instance status
    AND
    (
        (
            instance_ext.status_name IN (
                                            (SELECT instance_status_filter1 FROM parameters),
                                            (SELECT instance_status_filter2 FROM parameters)
                                        )
        )
        OR
        (
                (SELECT instance_status_filter1 FROM parameters) = ''
            AND (SELECT instance_status_filter2 FROM parameters) = ''
        )
    )
    -- instance type
    AND
    (
        (           
            instance_ext.type_name IN (
                                          (SELECT instance_type_filter1 FROM parameters),
                                          (SELECT instance_type_filter2 FROM parameters),
                                          (SELECT instance_type_filter3 FROM parameters)
                                      )
        )
        OR
        (
                (SELECT instance_type_filter1 FROM parameters) = ''
            AND (SELECT instance_type_filter2 FROM parameters) = ''
            AND (SELECT instance_type_filter3 FROM parameters) = ''
        )
    )
    -- instance format
    AND
    (
        (
               instance_formats.instance_format_name LIKE (SELECT instance_format_filter1 FROM parameters)
            OR instance_formats.instance_format_name LIKE (SELECT instance_format_filter2 FROM parameters) 
            OR instance_formats.instance_format_name LIKE (SELECT instance_format_filter3 FROM parameters)
        )
        OR
        (
                (SELECT instance_format_filter1 FROM parameters) = ''
            AND (SELECT instance_format_filter2 FROM parameters) = ''
            AND (SELECT instance_format_filter3 FROM parameters) = ''
        )
    )
    -- language
    AND (instance_languages.instance_language = (SELECT instance_language_filter FROM parameters) OR (SELECT instance_language_filter FROM parameters) = '')
    -- mode of issuance name
    AND (instance_ext.mode_of_issuance_name = (SELECT instance_mode_of_issuance_filter FROM parameters) OR (SELECT instance_mode_of_issuance_filter FROM parameters) = '')
    -- nature of content term name
    AND (instance_nature_content.nature_of_content_term_name = (SELECT nature_of_content_terms_filter FROM parameters) OR (SELECT nature_of_content_terms_filter FROM parameters) = '')
    -- receipt status
    AND (holdings_ext.receipt_status = (SELECT holdings_receipt_status_filter FROM parameters) OR (SELECT holdings_receipt_status_filter FROM parameters) = '')
    -- holdings type name
    AND (holdings_ext.type_name = (SELECT holdings_type_filter FROM  parameters) OR (SELECT holdings_type_filter FROM parameters) = '')
    -- call number type name
    AND (holdings_ext.call_number_type_name = (SELECT holdings_callnumber_type_filter FROM parameters) OR (SELECT holdings_callnumber_type_filter FROM parameters) = '')
    -- call number
    AND (holdings_ext.call_number LIKE (SELECT holdings_callnumber_filter FROM parameters) OR (SELECT holdings_callnumber_filter FROM parameters) = '')
    -- acquisition method
    AND (holdings_ext.acquisition_method = (SELECT holdings_acquisition_method_filter FROM parameters) OR (SELECT holdings_acquisition_method_filter FROM parameters) = '')
    -- instance statistical code name
    AND (instance_statistical_codes.statistical_code_name = (SELECT instance_statistical_code_filter FROM parameters) OR (SELECT instance_statistical_code_filter FROM parameters) = '')
    -- instance statistical code type name
    AND (instance_statistical_codes.statistical_code_type_name = (SELECT instance_statistical_code_type_filter FROM parameters) OR (SELECT instance_statistical_code_type_filter FROM parameters) = '')
    -- holdings statistical code name
    AND (holdings_statistical_codes.statistical_code_name = (SELECT holdings_statistical_code_filter FROM parameters) OR (SELECT holdings_statistical_code_filter FROM parameters) = '')
    -- location campus name
    AND (locations_libraries.campus_name = (SELECT campus_filter FROM parameters) OR (SELECT campus_filter FROM parameters) = '')
    -- location institution name
    AND (locations_libraries.institution_name = (SELECT institution_filter FROM parameters) OR (SELECT institution_filter FROM parameters) = '')
    -- location library name
    AND (locations_libraries.library_name = (SELECT library_filter FROM parameters) OR (SELECT library_filter FROM parameters) = '')
    -- holdings permanent location name
    AND (holdings_ext.permanent_location_name = (SELECT permanent_location_name_filter FROM parameters) OR (SELECT permanent_location_name_filter FROM parameters) = '')
GROUP BY
    instance_ext.type_id,
    instance_ext.type_name,
    instance_ext.mode_of_issuance_id,
    instance_ext.mode_of_issuance_name,
    instance_formats.instance_format_id,
    instance_formats.instance_format_code,
    instance_formats.instance_format_name,
    first_language,
    instance_statistical_codes.statistical_code_id,
    instance_statistical_codes.statistical_code,
    instance_statistical_codes.statistical_code_name,
    instance_nature_content.nature_of_content_term_id,
    instance_nature_content.nature_of_content_term_id,
    instance_nature_content.nature_of_content_term_name,
    holdings_ext.type_id,
    holdings_ext.type_name,
    holdings_ext.call_number_type_id,
    holdings_ext.call_number_type_name,
    holdings_statistical_codes.statistical_code_id,
    holdings_statistical_codes.statistical_code,
    holdings_statistical_codes.statistical_code_name,
    holdings_ext.receipt_status,
    locations_libraries.location_name,
    instance_ext.previously_held,
    super_relation.relationship_type_id,
    super_relation.relationship_type_name,
    sub_relation.relationship_type_id,
    sub_relation.relationship_type_name
;
