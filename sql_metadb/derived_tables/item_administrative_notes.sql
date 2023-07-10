--metadb:table item_administrative_notes

-- This derived table extracts administrative notes from the item
-- record.

DROP TABLE IF EXISTS item_administrative_notes;

CREATE TABLE item_administrative_notes AS
SELECT
    i.id AS item_id,
    i.hrid AS item_hrid,
    i.holdings_record_id AS holdings_record_id,
    admin_notes.jsonb #>> '{}' AS administrative_note,
    admin_notes.ordinality AS administrative_note_ordinality
FROM
    folio_inventory.item
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(jsonb, 'administrativeNotes')) WITH ORDINALITY AS admin_notes (jsonb)
    LEFT JOIN folio_inventory.item__t AS i ON item.id = i.id;

