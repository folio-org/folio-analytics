-- This derived table extracts administrative notes from the instance
-- record.

DROP TABLE IF EXISTS holdings_administrative_notes;

CREATE TABLE holdings_administrative_notes AS
SELECT
    h.id AS holdings_id,
    h.hrid AS holdings_hrid,
    admin_note.data #>> '{}' AS administrative_note,
    admin_note.ordinality AS administrative_note_ordinality
FROM
    inventory_holdings AS h
    CROSS JOIN LATERAL json_array_elements(json_extract_path(data, 'administrativeNotes'))
WITH ORDINALITY AS admin_note (data);

CREATE INDEX ON holdings_administrative_notes (holdings_id);

CREATE INDEX ON holdings_administrative_notes (holdings_hrid);

CREATE INDEX ON holdings_administrative_notes (administrative_note);

CREATE INDEX ON holdings_administrative_notes (administrative_note_ordinality);

VACUUM ANALYZE holdings_administrative_notes;
