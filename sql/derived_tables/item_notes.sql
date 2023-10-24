DROP TABLE IF EXISTS item_notes;

-- Create a local table for notes in item records. Here note is a public note.
CREATE TABLE item_notes AS
SELECT
    items.id AS item_id,
    items.hrid AS item_hrid,
    holdings_record_id AS holdings_record_id,
    notes.data #>> '{itemNoteTypeId}' AS note_type_id,
    item_note_types.name AS note_type_name,
    notes.data #>> '{note}' AS note,
    (notes.data #>> '{staffOnly}')::boolean AS staff_only,
    notes.ordinality AS note_ordinality
FROM
    inventory_items AS items
    CROSS JOIN LATERAL jsonb_array_elements((data #> '{notes}')::jsonb) WITH ORDINALITY AS notes (data)
    LEFT JOIN inventory_item_note_types AS item_note_types
        ON (notes.data #>> '{itemNoteTypeId}')::uuid = item_note_types.id::uuid;
