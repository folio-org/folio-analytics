-- This derived table extracts subjects from the FOLIO Instance record
DROP TABLE IF EXISTS instance_subjects;

CREATE TABLE instance_subjects AS 
SELECT 
	it.id AS instance_id,
	it.hrid AS instance_hrid,
	instsubjects.jsonb #>> '{}' AS subjects,
    instsubjects.ordinality AS subjects_ordinality
FROM 
	folio_inventory.instance__t AS it
	LEFT JOIN folio_inventory.instance AS inst ON inst.id = it.id
	CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(inst.jsonb, 'subjects')) WITH ORDINALITY AS instsubjects (jsonb);
	
CREATE INDEX ON instance_subjects (instance_id);

CREATE INDEX ON instance_subjects (instance_hrid);

CREATE INDEX ON instance_subjects (subjects);

CREATE INDEX ON instance_subjects (subjects_ordinality);

VACUUM ANALYZE instance_subjects;
