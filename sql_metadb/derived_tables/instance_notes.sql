--metadb:table instance_notes

-- This derived table extracts note information from the FOLIO
-- instance record

DROP TABLE IF EXISTS instance_notes;

CREATE TABLE instance_notes AS 
SELECT 
    i.id AS instance_id,
    jsonb_extract_path_text(i.jsonb, 'hrid') AS instance_hrid,
    jsonb_extract_path_text(n.jsonb, 'note') AS instance_note,
    jsonb_extract_path_text(n.jsonb, 'staffOnly')::boolean AS staff_only_note,
    jsonb_extract_path_text(n.jsonb, 'instanceNoteTypeId')::uuid AS instance_note_type_id,
    notetype.name AS instance_note_type_name,
    n.ordinality AS instance_notes_ordinality
FROM
    folio_inventory.instance AS i
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(i.jsonb, 'notes')) WITH ORDINALITY AS n (jsonb)
    LEFT JOIN folio_inventory.instance_note_type__t AS notetype ON jsonb_extract_path_text(n.jsonb, 'instanceNoteTypeId')::uuid = notetype.id;

