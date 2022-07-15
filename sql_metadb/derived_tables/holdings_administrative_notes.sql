-- This derived table extracts administrative notes from the holdings record.

DROP TABLE IF EXISTS holdings_administrative_notes;

CREATE TABLE holdings_administrative_notes AS 
SELECT 
    h.instance_id,
    h.id AS holdings_id,
    h.hrid AS holdings_hrid,
    admin_notes.jsonb #>> '{}' AS administrative_note,
    admin_notes.ordinality AS administrative_note_ordinality
FROM 
    folio_inventory.holdings_record__t AS h
    LEFT JOIN folio_inventory.holdings_record ON h.id = holdings_record.id
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(holdings_record.jsonb, 'administrativeNotes')) WITH ORDINALITY AS admin_notes (jsonb);
    
CREATE INDEX ON holdings_administrative_notes (instance_id);

CREATE INDEX ON holdings_administrative_notes (holdings_id);

CREATE INDEX ON holdings_administrative_notes (holdings_hrid);

CREATE INDEX ON holdings_administrative_notes (administrative_note);

CREATE INDEX ON holdings_administrative_notes (administrative_note_ordinality);

VACUUM ANALYZE holdings_administrative_notes;
