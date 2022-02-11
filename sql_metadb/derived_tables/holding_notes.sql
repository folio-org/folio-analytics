DROP TABLE IF EXISTS holdings_notes;
CREATE TABLE IF EXISTS holdings_notes;
WITH notes AS (
    SELECT 
    h.instanceid AS instance_id,
    h.id AS holdings_id,
    jsonb_extract_path_text(h.jsonb, 'hrid') AS holdings_hrid,
    jsonb_extract_path_text(notes.jsonb, 'note') AS note,
    jsonb_extract_path_text(notes.jsonb, 'holdingsNoteTypeId')::uuid AS holdings_note_type_id,
    notes.ordinality AS notes_ordinality
    FROM 
    folio_inventory.holdings_record h
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(h.jsonb, 'notes'))
    WITH ordinality AS notes (jsonb))
SELECT    
    n.instance_id,
    jsonb_extract_path_text(i.jsonb, 'hrid') AS instance_hrid,   
    n.holdings_id,
    n.holdings_hrid,
    n.note,
    hntt.name AS note_name, 
    n.holdings_note_type_id,
    n.notes_ordinality,
    hnt.creation_date AS note_date_created,
    hnt.created_by AS created_by_uuid,
    jsonb_extract_path_text(hnt.jsonb, 'metadata', 'updatedDate') AS note_date_updated,
    jsonb_extract_path_text(hnt.jsonb, 'metadata', 'updatedByUserId')::uuid AS updated_by_uuid
    FROM notes AS n
    LEFT JOIN folio_inventory.INSTANCE i ON n.instance_id = i.id
    LEFT JOIN folio_inventory.holdings_note_type AS hnt ON n.holdings_note_type_id = hnt.id
    LEFT JOIN folio_inventory.holdings_note_type__t hntt ON n.holdings_note_type_id = hntt.id
;
CREATE INDEX ON holdings_notes (instance_id);
CREATE INDEX ON holdings_notes (instance_hrid);
CREATE INDEX ON holdings_notes (holdings_id);
CREATE INDEX ON holdings_notes (holdings_hrid);
CREATE INDEX ON holdings_notes (note);
CREATE INDEX ON holdings_notes (note_name);
CREATE INDEX ON holdings_notes (holdings-note_type_id);
CREATE INDEX ON holdings_notes (notes_ordinality);
CREATE INDEX ON hldings_notes (note_date_created);
CREATE INDEX ON holdings_notes (creatd_by_uuid);
CREATE INDEX ON hldings_notes (note_date_updated);
CREATE INDEX ON holdings_notes (updated_by_uuid);
VACUUM ANALYZE holdings_notes;
