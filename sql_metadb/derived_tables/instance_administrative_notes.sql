--metadb:table instance_administrative_notes

-- This derived table extracts administrative notes from the instance
-- record.

DROP TABLE IF EXISTS instance_administrative_notes;

CREATE TABLE instance_administrative_notes AS
SELECT
    i.id AS instance_id,
    i.hrid AS instance_hrid,
    admin_note.jsonb #>> '{}' AS administrative_note,
    admin_note.ordinality AS administrative_note_ordinality
FROM
    folio_inventory.instance__t AS i
    LEFT JOIN folio_inventory.instance AS inst ON inst.id = i.id
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(inst.jsonb, 'administrativeNotes')) WITH ORDINALITY AS admin_note (jsonb);

CREATE INDEX ON instance_administrative_notes (instance_id);

CREATE INDEX ON instance_administrative_notes (instance_hrid);

CREATE INDEX ON instance_administrative_notes (administrative_note);

CREATE INDEX ON instance_administrative_notes (administrative_note_ordinality);

