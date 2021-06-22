/*
Filters: 
Fields Included:
	Instance_ext Folio Reporting table:
		Instance id
		Instance hrid
		Instance Status Name
		Resource type
		Mode of issuance
	Instance_identifiers Folio Reporting table:
		Name of the identifier type
		Value of the identifier
	Holdings ext Folio Reporting table:
		Holdings id
		Holdings hrid
		Holdings type name
	Item ext Folio Reporting table:
		Item id
		Item hrid
		Item chronology
		Item enumeration
		Item material type name
		Item status name
	Item Statistical Codes Folio Reporting table:
		Item statistical type code name
		Item statistical code name 
	Holdings Statistical Codes Folio Reporting table:
		Holdings statistical type code name
		Holdings statistical code name 
	Instance Statistical Codes Folio Reporting table:
		Instance statistical type code name
		Instance statistical code name 
	Instance Identifiers Folio Reporting table:
		Identifier type name
	Instance Formats Folio Reporting table:
		Format name
	Locations_libraries Folio Reporting table:
		Library name
		Campus name
		Institution name
*/
WITH parameters AS (
	SELECT
	 ---- Fill out one, leave others blank to filter location name or code ----
        '' ::VARCHAR AS institution_filter, -- 'KÃ¸benhavns Universitet','Montoya College'
        '' ::VARCHAR AS campus_filter, -- 'Main Campus','City Campus','Online'
        '' ::VARCHAR AS library_filter, -- 'Datalogisk Institut','Adelaide Library'
        '' ::VARCHAR AS location_filter, -- 'Main Library','Annex','Online'
        '' ::VARCHAR AS mode_of_issuance_filter, -- 'single unit', 'monograph'
        '' ::VARCHAR AS holdings_type_filter, -- 'Monograph'
        '' ::VARCHAR AS status_name_filter, -- 'Cataloged'
        '' ::VARCHAR AS identifier_filter, -- 'OCLC'
        '' ::VARCHAR AS format_filter, -- 'unmediated -- volume'
        '' ::VARCHAR AS resource_type_filter1, -- 'text'
        '' ::VARCHAR AS resource_type_filter2, -- 'cartographic image'
        '' ::VARCHAR AS resource_type_filter3 -- 'notated music'
),
location_filtering AS (
	SELECT
		ii.id AS i_id,
		loc.location_id,
		loc.location_name,
		loc.campus_id,
		loc.campus_name,
		loc.library_id,
		loc.library_name,
		loc.institution_id,
		loc.institution_name
	FROM 
		inventory_items AS ii
		LEFT JOIN folio_reporting.locations_libraries AS loc ON ii.effective_location_id = loc.location_id 
	WHERE 
		loc.institution_name = (SELECT institution_filter FROM parameters)
        OR loc.campus_name = (SELECT campus_filter FROM parameters)
        OR loc.library_name = (SELECT library_filter FROM parameters)
        OR loc.location_name = (SELECT location_filter FROM parameters)
),
statistical_codes AS (
	SELECT
		ie.item_id,
		isc.statistical_code_type_name AS item_stat_code_type_name,
		isc.statistical_code_name AS item_stat_code_name,
		he.holdings_id,
		hsc.statistical_code_type_name AS hol_stat_code_type_name,
		hsc.statistical_code_name AS hol_stat_code_name,
		ie2.instance_id,
		isc3.statistical_code_type_name AS inst_stat_code_type_name,
		isc3.statistical_code_name AS inst__stat_code_name
	FROM 
		folio_reporting.item_ext AS ie 
		LEFT JOIN folio_reporting.item_statistical_codes AS isc ON ie.item_id = isc.item_id
		LEFT JOIN folio_reporting.holdings_ext AS he ON ie.holdings_record_id = he.holdings_id 
		LEFT JOIN folio_reporting.instance_ext AS ie2 ON he.instance_id = ie2.instance_id 
		LEFT JOIN folio_reporting.holdings_statistical_codes AS hsc ON  he.holdings_id = hsc.holdings_id 
		LEFT JOIN folio_reporting.instance_statistical_codes AS isc3 ON ie2.instance_id = isc3.instance_id
)
SELECT 
	frie.item_id,
	frie.item_hrid,
	frie.material_type_name AS item_material_type,
	frie.chronology,
	frie.enumeration,
	frie.status_name AS item_status_name,
	inst.instance_id,
	inst.instance_hrid,
	inst.status_name AS instance_status_name,
	inst.type_name AS instance_resource_type,
	inst.mode_of_issuance_name AS instance_mode_of_issuance,
	instind.identifier_type_name AS instance_identifier_name,
	instind.identifier AS instance_identifier,
	if2.format_name AS instance_format,
	iht."name" AS holdings_type_name,
	statcodes.item_stat_code_type_name,
	statcodes.item_stat_code_name,
	statcodes.hol_stat_code_type_name,
	statcodes.hol_stat_code_name,
	statcodes.inst_stat_code_type_name,
	statcodes.inst__stat_code_name,
	loc_fil.location_name,
	loc_fil.campus_name,
	loc_fil.library_name,
	loc_fil.institution_name
FROM 
	folio_reporting.item_ext AS frie
	LEFT JOIN location_filtering AS loc_fil ON frie.item_id = loc_fil.i_id
	LEFT JOIN folio_reporting.holdings_ext AS hol ON frie.holdings_record_id = hol.holdings_id
	LEFT JOIN folio_reporting.instance_ext AS inst ON hol.instance_id = inst.instance_id 
	LEFT JOIN folio_reporting.item_statistical_codes AS itmsc ON frie.item_id = itmsc.item_id 
	LEFT JOIN folio_reporting.holdings_statistical_codes AS holsc ON hol.holdings_id = holsc.holdings_id
	LEFT JOIN folio_reporting.instance_statistical_codes AS insc ON inst.instance_id = insc.instance_id
	LEFT JOIN folio_reporting.instance_identifiers AS instind ON inst.instance_id = instind.instance_id 
	LEFT JOIN folio_reporting.instance_formats AS if2 ON inst.instance_id = if2.instance_id 
	LEFT JOIN inventory_holdings_types AS iht ON hol.type_id = iht.id 
	LEFT JOIN statistical_codes AS statcodes ON frie.item_id = statcodes.item_id
-- Filters
WHERE
	(loc_fil.institution_name = (SELECT institution_filter FROM parameters) OR (SELECT institution_filter FROM parameters) = '')
AND
	(loc_fil.campus_name = (SELECT campus_filter FROM parameters) OR (SELECT campus_filter FROM parameters) = '')
AND 
	(loc_fil.library_name = (SELECT library_filter FROM parameters) OR (SELECT library_filter FROM parameters) = '')
AND 
	(loc_fil.location_name = (SELECT location_filter FROM parameters) OR (SELECT location_filter FROM parameters) = '')
AND
	(inst.type_name = (SELECT resource_type_filter1 FROM parameters) OR (SELECT resource_type_filter1 FROM parameters) = '')
AND
	(inst.type_name = (SELECT resource_type_filter2 FROM parameters) OR (SELECT resource_type_filter2 FROM parameters) = '')
AND
	(inst.type_name = (SELECT resource_type_filter3 FROM parameters) OR (SELECT resource_type_filter3 FROM parameters) = '')
AND 
	(iht."name" = (SELECT holdings_type_filter FROM parameters) OR (SELECT holdings_type_filter FROM parameters) = '')
AND 
	(inst.status_name = (SELECT status_name_filter FROM parameters) OR (SELECT status_name_filter FROM parameters) = '')
AND 
	(inst.mode_of_issuance_name = (SELECT mode_of_issuance_filter FROM parameters) OR (SELECT mode_of_issuance_filter FROM parameters) = '')
AND 
	(instind.identifier_type_name = (SELECT identifier_filter FROM parameters) OR (SELECT identifier_filter FROM parameters) = '')
AND 
	(if2.format_name = (SELECT format_filter FROM parameters) OR (SELECT format_filter FROM parameters) = '')
;