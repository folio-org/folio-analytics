-- This derived table extracts administrative notes from the item
-- record.

DROP TABLE IF EXISTS item_administrative_notes;

CREATE TABLE item_administrative_notes AS
SELECT
    i.id AS item_id,
    i.hrid AS item_hrid,
    i.holdings_record_id AS holdings_record_id,
    admin_notes.data #>> '{}' AS administrative_note,
    admin_notes.ordinality AS administrative_note_ordinality
FROM
    public.inventory_items AS i
    CROSS JOIN LATERAL jsonb_array_elements((data #> '{administrativeNotes}')::jsonb)
        WITH ORDINALITY AS admin_notes (data);

CREATE INDEX ON item_administrative_notes (item_id);

CREATE INDEX ON item_administrative_notes (item_hrid);

CREATE INDEX ON item_administrative_notes (holdings_record_id);
