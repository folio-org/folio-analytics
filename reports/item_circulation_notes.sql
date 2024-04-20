--metadb:function item_circulation_notes

DROP FUNCTION IF EXISTS item_circulation_notes;

CREATE FUNCTION item_circulation_notes()
RETURNS TABLE(
    item_id uuid,
    note_id uuid,
    note text,
    note_type text,
    staff_only boolean,
    ordinality bigint)
AS $$
SELECT item.id AS item_id,
       jsonb_extract_path_text(notes.jsonb, 'id')::uuid AS note_id,
       jsonb_extract_path_text(notes.jsonb, 'note') AS note,
       jsonb_extract_path_text(notes.jsonb, 'noteType') AS note_type,
       jsonb_extract_path_text(notes.jsonb, 'staffOnly')::boolean AS staff_only,
       notes.ordinality
FROM folio_inventory.item
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(jsonb, 'circulationNotes'))
        WITH ORDINALITY AS notes (jsonb);
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
