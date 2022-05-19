-- This derived table extracts classification values, ids, and names from the instance.
DROP TABLE IF EXISTS instance_classifications;

CREATE TABLE instance_classifications AS 
SELECT
	it.id AS instance_id,
	it.hrid AS instance_hrid,
	jsonb_extract_path_text(instclass.jsonb, 'classificationNumber') AS classification_number,
	jsonb_extract_path_text(instclass.jsonb, 'classificationTypeId')::uuid AS classification_type_id,
	instclass.ordinality AS classification_ordinality,
	ctt.name AS classification_name
FROM 
	folio_inventory.instance__t AS it 
	LEFT JOIN folio_inventory.instance AS inst ON inst.id::uuid = it.id::uuid
	CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(inst.jsonb, 'classifications')) WITH ORDINALITY AS instclass (jsonb)
	LEFT JOIN folio_inventory.classification_type__t AS ctt ON jsonb_extract_path_text(instclass.jsonb, 'classificationTypeId')::uuid = ctt.id::uuid ;

CREATE INDEX ON instance_classifications (instance_id);

CREATE INDEX ON instance_classifications (instance_hrid);

CREATE INDEX ON instance_classifications (classification_number);

CREATE INDEX ON instance_classifications (classification_type_id);

CREATE INDEX ON instance_classifications (classification_ordinality);

CREATE INDEX ON instance_classifications (classification_name);

VACUUM ANALYZE instance_classifications;
