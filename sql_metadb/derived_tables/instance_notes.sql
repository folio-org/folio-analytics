--metadb:table instance_notes

-- This derived table extracts note information from the FOLIO
-- instance record

DROP TABLE IF EXISTS instance_notes;

CREATE TABLE instance_notes AS 
SELECT 
    inst.id AS instance_id,
    inst.hrid AS instance_hrid,
    jsonb_extract_path_text(instnotes.jsonb, 'note') AS instance_note,
    jsonb_extract_path_text(instnotes.jsonb, 'staffOnly')::boolean AS staff_only_note,
    jsonb_extract_path_text(instnotes.jsonb, 'instanceNoteTypeId')::uuid AS instance_note_type_id,
    notetype.name AS instance_note_type_name,
    instnotes.ordinality AS instance_notes_ordinality
FROM
    folio_inventory.instance__t AS inst
    LEFT JOIN folio_inventory.instance ON instance.id::uuid = inst.id::uuid
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(instance.jsonb, 'notes')) WITH ORDINALITY AS instnotes (jsonb)
    LEFT JOIN folio_inventory.instance_note_type__t AS notetype ON jsonb_extract_path_text(instnotes.jsonb, 'instanceNoteTypeId')::uuid = notetype.id::uuid;

