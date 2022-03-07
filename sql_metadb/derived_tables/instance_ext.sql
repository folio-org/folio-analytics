-- Create an extended version of the instance table where the names for identifiers are included
-- This derived table doesn't include all the properties extracted from the json objects
-- For example, electronic access, notes, publication, series, or edition statements have their own 
-- derived tables.
DROP TABLE IF EXISTS instance_ext;

CREATE TABLE instance_ext AS 
WITH expanded_inst AS (
	SELECT 
		i.id AS instance_id,
		jsonb_extract_path_text(i.jsonb, 'hrid') AS instance_hrid,
		jsonb_extract_path_text(i.jsonb, '_version') AS record_version,
		jsonb_extract_path_text(i.jsonb, 'matchKey') AS match_key,
		jsonb_extract_path_text(i.jsonb, 'source') AS record_source,
		jsonb_extract_path_text(i.jsonb, 'discoverySuppress')::boolean AS discovery_suppress,
		jsonb_extract_path_text(i.jsonb, 'staffSuppress')::boolean AS staff_suppress,
		jsonb_extract_path_text(i.jsonb, 'previouslyHeld')::boolean AS previously_held,
		jsonb_extract_path_text(i.jsonb, 'isBoundWith')::boolean AS is_bound_with,
		jsonb_extract_path_text(i.jsonb, 'instanceTypeId')::uuid AS instance_type_id,
		itt.name AS instance_type_name,
		jsonb_extract_path_text(i.jsonb, 'title') AS title,
		jsonb_extract_path_text(i.jsonb, 'indexTitle') AS index_title,
    	jsonb_extract_path_text(classes.jsonb, 'classificationNumber') AS classification_number,
    	jsonb_extract_path_text(classes.jsonb, 'classificationTypeId')::uuid AS classification_type_id,
    	ctt.name AS classification_type_name,
    	classes.ORDINALITY AS classification_ordinality,
    	physdescript.jsonb #>> '{}' AS physical_description,
    	physdescript.ordinality AS physical_description_ordinality,
    	jsonb_extract_path_text(i.jsonb, 'modeOfIssuanceId')::uuid AS mode_of_issuance_id,
    	moit.name AS mode_of_issuance_name,
    	jsonb_extract_path_text(i.jsonb, 'administrativeNotes') AS administrative_notes,
    	jsonb_extract_path_text(i.jsonb, 'catalogedDate')::date AS cataloged_date,
    	jsonb_extract_path_text(i.jsonb, 'metadata', 'createdDate')::date AS created_date,
    	jsonb_extract_path_text(i.jsonb, 'metadata', 'updatedDate')::date AS updated_date
	FROM 
		folio_inventory.instance  AS i
   		CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(i.jsonb, 'classifications')) WITH ORDINALITY AS classes (jsonb)
		CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(i.jsonb, 'physicalDescriptions')) WITH ORDINALITY AS physdescript (jsonb)
		LEFT JOIN folio_inventory.classification_type__t AS ctt ON jsonb_extract_path_text(classes.jsonb, 'classificationTypeId')::uuid = ctt.id
		LEFT JOIN folio_inventory.mode_of_issuance__t AS moit ON jsonb_extract_path_text(i.jsonb, 'modeOfIssuanceId')::uuid = moit.id 
		LEFT JOIN folio_inventory.instance_type__t AS itt ON jsonb_extract_path_text(i.jsonb, 'instanceTypeId')::uuid = itt.id 
)
SELECT
	instance_id,
	instance_hrid,
	record_version,
	match_key,
	record_source,
	discovery_suppress,
	staff_suppress,
	previously_held,
	is_bound_with,
	instance_type_id,
	instance_type_name,
	title,
	index_title,
	classification_number,
	classification_type_id,
	classification_type_name,
	classification_ordinality,
	physical_description,
	physical_description_ordinality,
	mode_of_issuance_id,
	mode_of_issuance_name,
	administrative_notes,
	cataloged_date,
	created_date,
	updated_date
FROM
	expanded_inst ;
	
CREATE INDEX ON instance_ext (instance_id);

CREATE INDEX ON instance_ext (instance_hrid);

CREATE INDEX ON instance_ext (record_version);

CREATE INDEX ON instance_ext (match_key);

CREATE INDEX ON instance_ext (record_source);

CREATE INDEX ON instance_ext (discovery_suppress);

CREATE INDEX ON instance_ext (staff_suppress);

CREATE INDEX ON instance_ext (previously_held);

CREATE INDEX ON instance_ext (is_bound_with);

CREATE INDEX ON instance_ext (instance_type_id);

CREATE INDEX ON instance_ext (instance_type_name);

CREATE INDEX ON instance_ext (title);

CREATE INDEX ON instance_ext (index_title);

CREATE INDEX ON instance_ext (classification_number);

CREATE INDEX ON instance_ext (classification_type_id);

CREATE INDEX ON instance_ext (classification_type_name);

CREATE INDEX ON instance_ext (classification_ordinality);

CREATE INDEX ON instance_ext (physical_description);

CREATE INDEX ON instance_ext (physical_description_ordinality);

CREATE INDEX ON instance_ext (mode_of_issuance_id);

CREATE INDEX ON instance_ext (mode_of_issuance_name);

CREATE INDEX ON instance_ext (administrative_notes);

CREATE INDEX ON instance_ext (cataloged_date);

CREATE INDEX ON instance_ext (created_date);

CREATE INDEX ON instance_ext (updated_date);

VACUUM ANALYZE instance_ext; 