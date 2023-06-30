-- This derived table extracts administrative notes from the instance
-- record.

DROP TABLE IF EXISTS instance_administrative_notes;

CREATE TABLE instance_administrative_notes AS
SELECT
    i.id AS instance_id,
    i.hrid AS instance_hrid,
    admin_note.data #>> '{}' AS administrative_note,
    admin_note.ordinality AS administrative_note_ordinality
FROM
    inventory_instances AS i
    CROSS JOIN LATERAL jsonb_array_elements((data #> '{administrativeNotes}')::jsonb)
    WITH ORDINALITY AS admin_note (data);

