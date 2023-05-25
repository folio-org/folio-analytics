--metadb:table instance_electronic_access

--This derived table extracts data for the instance electronic access. 
--It includes the instance uuid, hrid, the electronic access uri, link text, materials specification, public note
--relationship id and relationship name.
--Ordinality has been included.
DROP TABLE IF EXISTS instance_electronic_access;

CREATE TABLE instance_electronic_access AS 
WITH eaccess AS (
	SELECT 
		i.id AS instance_id,
		jsonb_extract_path_text(i.jsonb, 'hrid') AS instance_hrid,
		jsonb_extract_path_text(elac.jsonb, 'uri') AS uri,
    	jsonb_extract_path_text(elac.jsonb, 'linkText') AS link_text,
    	jsonb_extract_path_text(elac.jsonb, 'materialsSpecification') AS materials_specification,
    	jsonb_extract_path_text(elac.jsonb, 'publicNote') AS public_note,
    	jsonb_extract_path_text(elac.jsonb, 'relationshipId')::uuid AS relationship_id,
    	elac.ordinality AS electronic_access_ordinality
	FROM 
		folio_inventory.instance i
		CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(i.jsonb, 'electronicAccess')) WITH ORDINALITY AS elac (jsonb)
)
SELECT 
	ea.instance_id,
	ea.instance_hrid,
	ea.uri,
	ea.link_text,
	ea.materials_specification,
	ea.public_note,
	ea.relationship_id,
	eart.name AS relationship_name,
	ea.electronic_access_ordinality 
FROM 
	eaccess AS ea
	LEFT JOIN folio_inventory.electronic_access_relationship__t AS eart ON ea.relationship_id = eart.id ;

