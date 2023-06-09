-- This derived table extracts administrative notes from the holdings
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
    CROSS JOIN LATERAL jsonb_array_elements((data->'administrativeNotes')::jsonb) WITH ORDINALITY
        AS admin_note (data);

