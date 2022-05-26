-- This derived table extracts administrative notes from the instance record.
DROP TABLE IF EXISTS instance_administrative_notes;

CREATE TABLE instance_administrative_notes AS 
SELECT 
	it.id AS instance_id,
	it.hrid AS instance_hrid,
	adminNotes.jsonb #>> '{}' AS administrative_notes,
	adminNotes.ordinality AS administrative_notes_ordinality
FROM 
	folio_inventory.instance__t AS it
	LEFT JOIN folio_inventory.instance AS inst ON inst.id = it.id 
	CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(inst.jsonb, 'administrativeNotes')) WITH ORDINALITY AS adminNotes (jsonb);
	
CREATE INDEX ON instance_administrative_notes (instance_id);

CREATE INDEX ON instance_administrative_notes (instance_hrid);

CREATE INDEX ON instance_administrative_notes (administrative_notes);

CREATE INDEX ON instance_administrative_notes (administrative_notes_ordinality);

VACUUM ANALYZE instance_administrative_notes;