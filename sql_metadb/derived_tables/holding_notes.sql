DROP TABLE IF EXISTS holdings_notes;
CREATE TABLE holdings_notes
WITH notes AS (
    SELECT 
    h.instanceid AS instance_id,
    h.id AS holding_id,
    jsonb_extract_path_text(h.jsonb, 'hrid') AS holding_hrid,
    jsonb_extract_path_text(notes.jsonb, 'note') AS note,
    jsonb_extract_path_text(notes.jsonb, 'holdingsNoteTypeId')::uuid AS holding_note_type_id,
    notes.ordinality AS note_ordinality
    FROM 
    folio_inventory.holdings_record h
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(h.jsonb, 'notes'))
    WITH ordinality AS notes (jsonb))
SELECT    
    n.instance_id,
    jsonb_extract_path_text(i.jsonb, 'hrid') AS instance_hrid,   
    n.holding_id,
    n.holding_hrid,
    n.note,
    hntt.name AS note_name, 
    n.holding_note_type_id,
    n.note_ordinality,
    hnt.creation_date AS note_date_created,
    hnt.created_by AS note_created_by_user_id,
    jsonb_extract_path_text(hnt.jsonb, 'updatedDate') AS note_date_updated,
    jsonb_extract_path_text(hnt.jsonb, 'updatedByUserId') AS updated_by_user_id
    FROM notes AS n
    LEFT JOIN folio_inventory.INSTANCE i ON n.instance_id = i.id
    LEFT JOIN folio_inventory.holdings_note_type AS hnt ON n.holding_note_type_id = hnt.id
    LEFT JOIN folio_inventory.holdings_note_type__t hntt ON n.holding_note_type_id = hntt.id
;
CREATE INDEX ON holdings_notes (instance_id);
CREATE INDEX ON holdings_notes (instance_hrid);
CREATE INDEX ON holdings_notes (holdings_id);
CREATE INDEX ON holdings_notes (holdings_hrid);
CREATE INDEX ON holdings_notes (note);
CREATE INDEX ON holdings_notes (holdings_note_type_id);
CREATE INDEX ON holdings_notes (note_name);
CREATE INDEX ON holdings_notes (staff_only_note);
CREATE INDEX ON holdings_notes (statistical_code_name);
CREATE INDEX ON holdings_notes (stat_code_ordinality);
VACUUM ANALYZE holdings_notes;
