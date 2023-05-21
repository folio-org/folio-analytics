--metadb:table item_notes

-- This derived table extracts the nested array item notes

DROP TABLE IF EXISTS item_notes;

CREATE TABLE item_notes AS
SELECT
    i.id AS item_id,
    i.hrid AS item_hrid,
    i.holdings_record_id AS holdings_record_id,
    jsonb_extract_path_text(notes.data, 'itemNoteTypeId')::uuid AS note_type_id,
    nt.name AS note_type_name,
    jsonb_extract_path_text(notes.data, 'note') AS note,
    jsonb_extract_path_text(notes.data, 'staffOnly')::boolean AS staff_only,
    notes.ordinality AS note_ordinality
FROM
    folio_inventory.item
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(jsonb, 'notes')) WITH ORDINALITY AS notes (data)
    LEFT JOIN folio_inventory.item__t AS i ON item.id = i.id
    LEFT JOIN folio_inventory.item_note_type__t AS nt ON jsonb_extract_path_text(notes.data, 'itemNoteTypeId')::uuid = nt.id;

CREATE INDEX ON item_notes (item_id);

CREATE INDEX ON item_notes (item_hrid);

CREATE INDEX ON item_notes (holdings_record_id);

CREATE INDEX ON item_notes (note_type_id);

CREATE INDEX ON item_notes (note_type_name);

CREATE INDEX ON item_notes (staff_only);

CREATE INDEX ON item_notes (note_ordinality);

