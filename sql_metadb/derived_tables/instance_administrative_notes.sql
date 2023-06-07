--metadb:table instance_administrative_notes

-- This derived table extracts administrative notes from the instance
-- record.

DROP TABLE IF EXISTS instance_administrative_notes;

CREATE TABLE instance_administrative_notes AS
SELECT
    i.id AS instance_id,
    i.jsonb->>'hrid' AS instance_hrid,
    admin_note.note #>> '{}' AS administrative_note,
    admin_note.ordinality AS administrative_note_ordinality
FROM
    folio_inventory.instance AS i
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(i.jsonb, 'administrativeNotes')) WITH ORDINALITY AS admin_note (note);

