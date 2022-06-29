-- This derived table extracts administrative notes from the holdings record.
DROP TABLE IF EXISTS holdings_administrative_notes;

CREATE TABLE holdings_administrative_notes AS 
SELECT 
    hd.instance_id,
    hd.id AS holding_id,
    hd.hrid AS holding_hrid,
    admin_notes.jsonb #>> '{}' AS administrative_note,
    admin_notes.ordinality AS administrative_note_ordinality
FROM 
    folio_inventory.holdings_record__t AS hd
    LEFT JOIN folio_inventory.holdings_record AS hld ON hd.id = hld.id 
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(hld.jsonb, 'administrativeNotes')) WITH ORDINALITY AS admin_notes (jsonb);
    
CREATE INDEX ON holdings_administrative_notes (instance_id);

CREATE INDEX ON holdings_administrative_notes (holding_id);

CREATE INDEX ON holdings_administrative_notes (holding_hrid);

CREATE INDEX ON holdings_administrative_notes (administrative_note);

CREATE INDEX ON holdings_administrative_notes (administrative_note_ordinality);

VACUUM ANALYZE holdings_administrative_notes;
