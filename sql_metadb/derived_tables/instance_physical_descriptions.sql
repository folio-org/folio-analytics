-- This derived Metadb table extracts information in the physical description including extent, illustrations, size.
DROP TABLE IF EXISTS instance_physical_descriptions;

CREATE TABLE instance_physical_descriptions AS
SELECT 
	it.id AS instance_id,
	it.hrid AS instance_hrid,
	instPhyDesc.jsonb #>> '{}' AS physical_description,
	instPhyDesc.ordinality AS physical_description_ordinality
FROM 
	folio_inventory.instance__t it 
	LEFT JOIN folio_inventory.instance AS inst ON inst.id = it.id 
	CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(inst.jsonb, 'physicalDescriptions')) WITH ORDINALITY AS instPhyDesc (jsonb);
	
CREATE INDEX ON instance_physical_descriptions (instance_id);

CREATE INDEX ON instance_physical_descriptions (instance_hrid);

CREATE INDEX ON instance_physical_descriptions (physical_description);

CREATE INDEX ON instance_physical_descriptions (physical_description_ordinality);

VACUUM ANALYZE instance_physical_descriptions;