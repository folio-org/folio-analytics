DROP TABLE IF EXISTS local.item_notes;

CREATE TABLE local.item_notes AS
SELECT
    items.id AS item_id,
    items.hrid AS item_hrid,
    holdings_record_id AS holdings_id,
    json_extract_path_text(notes.data, 'itemNoteTypeId') AS item_note_type_id,
    item_note_types.name AS item_note_type,
    json_extract_path_text(notes.data, 'note') AS note,
    json_extract_path_text(notes.data, 'staffOnly')::boolean AS staff_only
FROM
    inventory_items AS items
    CROSS JOIN json_array_elements(json_extract_path(data, 'notes')) AS notes (data)
    LEFT JOIN inventory_item_note_types AS item_note_types ON json_extract_path_text(notes.data, 'itemNoteTypeId') = item_note_types.id;

CREATE INDEX ON local.item_notes (item_id);

CREATE INDEX ON local.item_notes (item_hrid);

CREATE INDEX ON local.item_notes (holdings_id);

CREATE INDEX ON local.item_notes (item_note_type_id);

CREATE INDEX ON local.item_notes (item_note_type);

CREATE INDEX ON local.item_notes (note);

CREATE INDEX ON local.item_notes (staff_only);

