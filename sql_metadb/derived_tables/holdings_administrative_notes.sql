-- This derived table extracts administrative notes from the holdings record.
DROP TABLE IF EXISTS holdings_administrative_notes;

CREATE TABLE holdings_administrative_notes AS 
SELECT 
    hd.instance_id,
    hd.id AS holdings_id,
    hd.hrid AS holdings_hrid,
    adminNotes.jsonb #>> '{}' AS administrative_notes,
    admin_notes.ordinality AS administrative_note_ordinality
FROM 
    folio_inventory.holdings_record__t AS hd
    LEFT JOIN folio_inventory.holdings_record AS hld ON hd.id = hld.id 
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(hld.jsonb, 'administrativeNotes')) WITH ORDINALITY AS admin_notes (jsonb);
    
CREATE INDEX ON holdings_administrative_notes (instance_id);

CREATE INDEX ON holdings_administrative_notes (holdings_id);

CREATE INDEX ON holdings_administrative_notes (holdings_hrid);

CREATE INDEX ON holdings_administrative_notes (administrative_note);

CREATE INDEX ON holdings_administrative_notes (administrative_note_ordinality);

VACUUM ANALYZE holdings_administrative_notes;
