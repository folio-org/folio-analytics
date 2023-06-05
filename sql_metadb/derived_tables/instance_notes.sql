--metadb:table instance_notes

-- This derived table extracts note information from the FOLIO
-- instance record

DROP TABLE IF EXISTS instance_notes;

CREATE TABLE instance_notes AS 
SELECT 
    i.id AS instance_id,
    i.jsonb->>'hrid' AS instance_hrid,
    n.jsonb->>'note' AS instance_note,
    (n.jsonb->>'staffOnly')::boolean AS staff_only_note,
    (n.jsonb->>'instanceNoteTypeId')::uuid AS instance_note_type_id,
    notetype.name AS instance_note_type_name,
    n.ordinality AS instance_notes_ordinality
FROM
    folio_inventory.instance AS i
    CROSS JOIN LATERAL jsonb_array_elements(i.jsonb->'notes') WITH ORDINALITY AS n (jsonb)
    LEFT JOIN folio_inventory.instance_note_type__t AS notetype ON (n.jsonb->>'instanceNoteTypeId')::uuid = notetype.id;

