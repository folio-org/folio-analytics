-- This derived table extracts note information from the FOLIO instance record
DROP TABLE IF EXISTS instance_notes;

CREATE TABLE instance_notes AS 
SELECT 
	it.id AS instance_id,
	it.hrid AS instance_hrid,
	jsonb_extract_path_text(instnotes.jsonb, 'note') AS instance_note,
	jsonb_extract_path_text(instnotes.jsonb, 'staffOnly')::boolean AS staff_only_note,
	jsonb_extract_path_text(instnotes.jsonb, 'instanceNoteTypeId')::uuid AS instance_note_type_id,
	intt.name AS instance_note_type_name,
	instnotes.ordinality AS instance_notes_ordinality
FROM 
	folio_inventory.instance__t AS it
	LEFT JOIN folio_inventory.INSTANCE AS inst ON inst.id::uuid = it.id::uuid
	CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(inst.jsonb, 'notes')) WITH ORDINALITY AS instnotes (jsonb)
	LEFT JOIN folio_inventory.instance_note_type__t AS intt ON jsonb_extract_path_text(instnotes.jsonb, 'instanceNoteTypeId')::uuid = intt.id::uuid ;
	
CREATE INDEX ON instance_notes (instance_id);

CREATE INDEX ON instance_notes (instance_hrid);

CREATE INDEX ON instance_notes (instance_note);

CREATE INDEX ON instance_notes (staff_only_note);

CREATE INDEX ON instance_notes (instance_note_type_id);

CREATE INDEX ON instance_notes (instance_note_type_name);

CREATE INDEX ON instance_notes (instance_notes_ordinality);

VACUUM ANALYZE instance_notes;