/** Documentation of ITEM COUNT QUERY

DERIVED TABLES
folio_reporting.items_ext
folio_reporting.items_stat_codes
folio_reporting.holdings_ext
folio_reporting.holdings_stat_codes 
folio_reporting.locations_libraries
folio_reporting.instances_ext
folio_reporting.instances_stat_codes
folio_reporting.instances_nature_content
folio_reporting.instance_formats
folio_reporting.instance_languages
folio_reporting.instance_relationships_ext

AGGREGATION

chronology, status_name, material_type_id, material_type_name, item_statistical_code_id, item_statistical_code, item_statistical_code_name, holdings_type_id,
holdings_type_name, holdings_callnumber_type_id,  holdings_callnumber_type_name, holdings_statistical_code_id, holdings_statistical_code, holdings_statistical_code_name,
holdings_receipt_status, location_name, type_id, type_name, mode_of_issuance_id, mode_of_issuance_name, format_id AS instance_format_id, instance_format_code, 
instance_format_name, first_language, instance_statistical_code_id, instance_statistical_code, instance_statistical_code_name, nature_of_content_id, 
nature_of_content_name, previously_held, instance_super_relation_relationship_type_id, instance_super_relation_relationship_type_name,
instance_sub_relation_relationship_type_id, instance_sub_relation_relationship_type_name, no_of_pieces_sum
 
FILTERS: FOR USERS TO SELECT
item_created_date, item_status_date, cataloged_date, item_status_filter, item_chronology_filter, item_description_of_pieces_filter, item_statistical_code_filter,
instance_type, instance_status, instance_format, mode_of_issuance, nature_of_content_terms, holdings_receipt_status, holdings_type, holdings_callnumber_type, 
holdings_callnumber, holdings_acquisition_method, instance_statistical_code, instance_statistical_code_type, holdings_statistical_code, 
permanent_location_discovery_name_filter, campus_filter, library_filter, institution_filter

HARDCODED FILTERS
instance_discovery_suppress, non-virtual titles by inform.format_name and loc.library_name

STILL IN PROGRESS:
Need adjustment in aggregation, filters, hardcoded filters 
 */
WITH parameters AS (
    SELECT
        '1950-04-01'::DATE AS item_created_start_date, --ex:2000-01-01
        '2020-05-01'::DATE AS item_created_end_date, -- ex:2020-01-01
        '1950-04-01'::DATE AS item_status_start_date, --ex:2000-01-01
        '2020-05-01'::DATE AS item_status_end_date, -- ex:2020-01-01
        '1950-04-01'::DATE AS cataloged_start_date, --ex:2000-01-01
        '2020-05-01'::DATE AS cataloged_end_date, -- ex:2020-01-01
        -- POSSIBLE FORMAT MEASURES -- USE EXACTLY EXACT TERM, CASE SENSITIVE. USE ONE FILTER FOR EACH SPECIFIC ELEMENT NEEDED
        ''::VARCHAR AS item_status_filter, -- select ... etc. or leave blank for all.
        ''::VARCHAR AS item_chronology_filter, -- use %% as wildcards '1234-abc%%','%%1234-abc','%%1234-abc%%'
        ''::VARCHAR AS item_description_of_pieces_filter, -- use %% as wildcards '1234-abc%%','%%1234-abc','%%1234-abc%%'
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
        ''::VARCHAR AS holdings_callnumber_type_filter, -- select 'LC Modified’, ‘Title’, ‘Shelved separately’ or leave blank for all.
        ''::VARCHAR AS holdings_callnumber_filter, -- use %% as wildcards '1234-abc%%','%%1234-abc','%%1234-abc%%'
        ''::VARCHAR AS holdings_acquisition_method_filter, -- select ‘Purchase’, ‘Approval’, ‘Gifts’ or leave blank for all.
        -- STATISTICAL CODES
        ''::VARCHAR AS item_statistical_code_filter, -- select ... etc. or leave blank for all.
        ''::VARCHAR AS holdings_statistical_code_filter, -- select 'Active Serial', 'Book, print (books)', 'Book, electronic (ebooks), 'Microfiche' etc. or leave blank for all.
        ''::VARCHAR AS instance_statistical_code_filter, -- select 'Active Serial', 'Book, print (books)', 'Book, electronic (ebooks), 'Microfiche' etc. or leave blank for all.
        ''::VARCHAR AS instance_statistical_code_type_filter, -- select ‘ARL (Collection stats)’, ‘DISC (Discovery)’ or leave blank for all.
        -- LOCATION
        ''::VARCHAR AS permanent_location_name_filter, --Online, Annex, Main Library
        ''::VARCHAR AS campus_filter, -- select 'Main Campus','City Campus','Online' as needed
        ''::VARCHAR AS library_filter, -- select 'Datalogisk Institut','Adelaide Library' as needed
        ''::VARCHAR AS institution_filter -- select 'Kobenhavns Universitet','Montoya College' as needed
)
SELECT
    item.chronology,
    item.status_name,
    item.material_type_id,
    item.material_type_name,
    itsc.statistical_code_id AS item_statistical_code_id,
    itsc.statistical_code AS item_statistical_code,
    itsc.statistical_code_name AS item_statistical_code_name,
    hld.type_id AS holdings_type_id,
    hld.type_name AS holdings_type_name,
    hld.call_number_type_id AS holdings_callnumber_type_id,
    hld.call_number_type_name AS holdings_callnumber_type_name,
    hsc.statistical_code_id AS holdings_statistical_code_id,
    hsc.statistical_code AS holdings_statistical_code,
    hsc.statistical_code_name AS holdings_statistical_code_name,
    hld.receipt_status AS holdings_receipt_status,
    loc.location_name,
    inst.type_id,
    inst.type_name,
    inst.mode_of_issuance_id,
    inst.mode_of_issuance_name,
    inform.format_id AS instance_format_id,
    inform.format_code AS instance_format_code,
    inform.format_name AS instance_format_name,
    lng.language AS first_language,
    insc.statistical_code_id AS instance_statistical_code_id,
    insc.statistical_code AS instance_statistical_code,
    insc.statistical_code_name AS instance_statistical_code_name,
    innc.nature_of_content_term_id AS nature_of_content_id,
    innc.nature_of_content_term_name AS nature_of_content_name,
    inst.previously_held,
    super_relation.relationship_type_id AS instance_super_relation_relationship_type_id,
    super_relation.relationship_type_name AS instance_super_relation_relationship_type_name,
    sub_relation.relationship_type_id AS instance_sub_relation_relationship_type_id,
    sub_relation.relationship_type_name AS instance_sub_relation_relationship_type_name,
    SUM(item.number_of_pieces::INT) "no_of_pieces_sum",
    COUNT(DISTINCT item.item_id) AS "item count"
FROM
    folio_reporting.item_ext AS item
    LEFT JOIN folio_reporting.item_statistical_codes AS itsc ON item.item_id = itsc.item_id
    LEFT JOIN folio_reporting.holdings_ext AS hld ON item.holdings_record_id = hld.holdings_id
    LEFT JOIN folio_reporting.holdings_statistical_codes AS hsc ON hld.holdings_id = hsc.holdings_id
    LEFT JOIN folio_reporting.locations_libraries AS loc ON hld.permanent_location_id = loc.location_id
    LEFT JOIN folio_reporting.instance_ext AS inst ON hld.instance_id = inst.instance_id
    LEFT JOIN folio_reporting.instance_statistical_codes AS insc ON inst.instance_id = insc.instance_id
    LEFT JOIN folio_reporting.instance_nature_content AS innc ON inst.instance_id = innc.instance_id
    LEFT JOIN folio_reporting.instance_formats AS inform ON inst.instance_id = inform.instance_id
    LEFT JOIN folio_reporting.instance_languages AS lng ON lng.instance_id = inst.instance_id AND lng.language_ordinality = 1
    LEFT JOIN folio_reporting.instance_relationships_ext AS super_relation ON super_relation.relationship_super_instance_id = inst.instance_id
    LEFT JOIN folio_reporting.instance_relationships_ext AS sub_relation ON sub_relation.relationship_sub_instance_id = inst.instance_id
WHERE
    -- hardcoded filters
	
	-- if suppressed don't count 
	(NOT inst.discovery_suppress 
		OR inst.discovery_suppress IS NULL)
	AND 
	(NOT hld.discovery_suppress 
		OR hld.discovery_suppress IS NULL)
	AND
	(NOT item.discovery_suppress 
		OR item.discovery_suppress IS NULL) 
	AND  
	-- filter all virtual titles (update values as needed).	
	(inform.format_name NOT IN  ('computer -- online resource') 
		OR  inform.format_name IS NULL)
	AND  
	-- only physical resources
	(loc.library_name  NOT IN  ('Online') 
		OR  loc.library_name IS NULL)
	AND
	-- begin to process the set filters
	/** 	this is commented out atm because of to few test data  	 	 	 	
	item.created_date :: DATE >= (SELECT item_created_start_date FROM parameters)
	AND
	item.created_date :: DATE < (SELECT item_created_end_date FROM parameters)
	AND		  	 	 	 	 	 	 	
	item.status_date :: DATE >= (SELECT item_status_start_date FROM parameters)
	AND
	item.status_date :: DATE < (SELECT item_status_end_date FROM parameters)
	AND	
	inst.cataloged_date :: DATE >= (SELECT cataloged_start_date FROM parameters)
	AND
	inst.cataloged_date :: DATE < (SELECT cataloged_end_date FROM parameters)
	AND
	*/
	(
		(inst.status_name  IN (
			(SELECT instance_status_filter1 FROM parameters),
			(SELECT instance_status_filter2 FROM parameters))
	)
	OR 
	(
		(SELECT instance_status_filter1 FROM parameters) = ''
		AND (SELECT instance_status_filter2 FROM parameters) = ''))
	AND
	(
		(inst.type_name IN (
			(SELECT instance_type_filter1 FROM parameters),
			(SELECT instance_type_filter2 FROM parameters),
			(SELECT instance_type_filter3 FROM parameters))
		)
		OR 
		(
			(SELECT instance_type_filter1 FROM parameters) = ''
			AND (SELECT instance_type_filter2 FROM parameters) = ''
			AND (SELECT instance_type_filter3 FROM parameters) = ''))
	AND 
	(
		(inform.format_name LIKE (SELECT instance_format_filter1 FROM parameters)
			OR inform.format_name LIKE (SELECT instance_format_filter2 FROM parameters)
			OR inform.format_name LIKE (SELECT instance_format_filter3 FROM parameters))
		OR 
		(
			(SELECT instance_format_filter1 FROM parameters) = ''
			AND (SELECT instance_format_filter2 FROM parameters) = ''
			AND (SELECT instance_format_filter3 FROM parameters) = ''))
	AND	
	(
        (lng.language = (SELECT instance_language_filter FROM parameters))
			OR ((SELECT instance_language_filter FROM parameters) = ''))
	AND 
	(inst.mode_of_issuance_name = (SELECT instance_mode_of_issuance_filter FROM parameters)
		OR (SELECT instance_mode_of_issuance_filter FROM parameters) = '')
	AND 
	(innc.nature_of_content_term_name = (SELECT nature_of_content_terms_filter FROM parameters)
		OR (SELECT nature_of_content_terms_filter FROM parameters) = '')
	AND 
	(hld.receipt_status = (SELECT holdings_receipt_status_filter FROM parameters)
		OR (SELECT holdings_receipt_status_filter FROM parameters) = '')
	AND 
	(hld.type_name = (SELECT holdings_type_filter FROM  parameters)
		OR (SELECT holdings_type_filter FROM parameters) = '')
	AND
	(hld.call_number_type_name = (SELECT holdings_callnumber_type_filter FROM parameters)
		OR (SELECT holdings_callnumber_type_filter FROM parameters) = '')
	AND 
	(hld.call_number LIKE (SELECT holdings_callnumber_filter FROM parameters)
		OR (SELECT holdings_callnumber_filter FROM parameters) = '')
	AND 
	(hld.acquisition_method = (SELECT holdings_acquisition_method_filter FROM parameters)
		OR (SELECT holdings_acquisition_method_filter FROM parameters) = '')
	AND 
	(insc.statistical_code_name = (SELECT instance_statistical_code_filter FROM parameters)
		OR (SELECT instance_statistical_code_filter FROM parameters) = '')
	AND 
	(insc.statistical_code_type_name = (SELECT instance_statistical_code_type_filter FROM parameters)
		OR (SELECT instance_statistical_code_type_filter FROM parameters) = '')			
	AND 
	(hsc.statistical_code_name = (SELECT holdings_statistical_code_filter FROM parameters)
		OR (SELECT holdings_statistical_code_filter FROM parameters) = '')
	AND 
	(itsc.statistical_code_name = (SELECT item_statistical_code_filter FROM parameters)
		OR (SELECT item_statistical_code_filter FROM parameters) = '')
	AND 
	(loc.campus_name = (SELECT campus_filter FROM parameters)
		OR (SELECT campus_filter FROM parameters) = '')
	AND 
	(loc.institution_name = (SELECT institution_filter FROM parameters)
		OR (SELECT institution_filter FROM parameters) = '')
	AND 
	(loc.library_name = (SELECT library_filter FROM parameters)
		OR (SELECT library_filter FROM parameters) = '')
	AND 
	(hld.permanent_location_name = (SELECT permanent_location_name_filter FROM parameters)
		OR (SELECT permanent_location_name_filter FROM parameters) = '')	
	AND 
	(item.chronology LIKE (SELECT item_chronology_filter FROM parameters)
		OR (SELECT item_chronology_filter FROM parameters) = '')
	AND 
	(item.description_of_pieces LIKE (SELECT item_description_of_pieces_filter FROM parameters)
		OR (SELECT item_description_of_pieces_filter FROM parameters) = '')

GROUP BY
    item.chronology,
    item.status_name,
    item.material_type_id,
    item.material_type_name,
    itsc.statistical_code_id,
    itsc.statistical_code,
    itsc.statistical_code_name,
    hld.type_id,
    hld.type_name,
    hld.call_number_type_id,
    hld.call_number_type_name,
    hsc.statistical_code_id,
    hsc.statistical_code,
    hsc.statistical_code_name,
    hld.receipt_status,
    loc.location_name,
    inst.type_id,
    inst.type_name,
    inst.mode_of_issuance_id,
    inst.mode_of_issuance_name,
    inform.format_id,
    inform.format_code,
    inform.format_name,
    first_language,
    insc.statistical_code_id,
    insc.statistical_code,
    insc.statistical_code_name,
    innc.nature_of_content_term_id,
    innc.nature_of_content_term_name,
    inst.previously_held,
    super_relation.relationship_type_id,
    super_relation.relationship_type_name,
    sub_relation.relationship_type_id,
    sub_relation.relationship_type_name;

