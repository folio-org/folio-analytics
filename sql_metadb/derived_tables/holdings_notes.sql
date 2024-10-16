--metadb:table holdings_notes

DROP TABLE IF EXISTS holdings_notes;

CREATE TABLE holdings_notes AS
SELECT 
    h.instanceid AS instance_id,
    instance__t.hrid as instance_hrid,
    h.id AS holding_id,
    jsonb_extract_path_text (h.jsonb, 'hrid') AS holding_hrid,
    jsonb_extract_path_text (notes.jsonb, 'note') AS note,
    holdings_note_type__t.name as note_type_name,
    jsonb_extract_path_text(notes.jsonb, 'holdingsNoteTypeId')::uuid AS note_type_id,
    notes.ordinality AS note_ordinality,
    jsonb_extract_path_text (h.jsonb,'metadata','createdDate')::timestamptz as note_date_created,
    jsonb_extract_path_text (h.jsonb,'metadata','createdByUserId') as note_created_by_user_id,
    jsonb_extract_path_text (h.jsonb,'metadata','updatedDate')::timestamptz as note_date_updated,
    jsonb_extract_path_text (h.jsonb,'metadata','updatedByUserId') as note_updated_by_user_id
FROM folio_inventory.holdings_record AS h
        CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path (h.jsonb, 'notes')) WITH ORDINALITY AS notes (jsonb)
    LEFT JOIN folio_inventory.instance__t on h.instanceid = instance__t.id
    LEFT JOIN folio_inventory.holdings_note_type__t ON jsonb_extract_path_text(notes.jsonb, 'holdingsNoteTypeId')::uuid = holdings_note_type__t.id
;
