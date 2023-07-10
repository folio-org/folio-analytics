--metadb:table holdings_administrative_notes

-- This derived table extracts administrative notes from the holdings record.

DROP TABLE IF EXISTS holdings_administrative_notes;

CREATE TABLE holdings_administrative_notes AS 
SELECT 
    h.instanceid AS instance_id,
    h.id AS holdings_id,
    jsonb_extract_path_text(h.jsonb, 'hrid') AS holdings_hrid,
    admin_notes.jsonb #>> '{}' AS administrative_note,
    admin_notes.ordinality AS administrative_note_ordinality
FROM 
    folio_inventory.holdings_record AS h
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(h.jsonb, 'administrativeNotes')) WITH ORDINALITY AS admin_notes (jsonb);
    
COMMENT ON COLUMN holdings_administrative_notes.instance_id IS 'Inventory instances identifier';

COMMENT ON COLUMN holdings_administrative_notes.holdings_id IS 'the unique ID of the holdings record, UUID'; 

COMMENT ON COLUMN holdings_administrative_notes.holdings_hrid IS 'the human readable ID, also called eye readable ID. A system-assigned sequential ID which maps to the Instance ID';

COMMENT ON COLUMN holdings_administrative_notes.administrative_note IS 'Administrative notes';

COMMENT ON COLUMN holdings_administrative_notes.administrative_note_ordinality IS 'Administrative note ordinality';

