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
    CROSS JOIN LATERAL json_array_elements(json_extract_path(data, 'administrativenotes'))
    WITH ORDINALITY AS admin_note (data);

CREATE INDEX ON instance_administrative_notes (instance_id);

CREATE INDEX ON instance_administrative_notes (instance_hrid);

CREATE INDEX ON instance_administrative_notes (administrative_note);

CREATE INDEX ON instance_administrative_notes (administrative_note_ordinality);

VACUUM ANALYZE instance_administrative_notes;
