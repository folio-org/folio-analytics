DROP TABLE IF EXISTS instance_notes;

-- Create a local table for notes in instance records that includes the type id and name. Here note can be either public or for staff.
CREATE TABLE instance_notes AS
SELECT
    instances.id AS instance_id,
    instances.hrid AS instance_hrid,
    notes.data #>> '{instanceNoteTypeId}' AS note_type_id,
    instance_note_types.name AS note_type_name,
    notes.data #>> '{note}' AS note,
    (notes.data #>> '{staffOnly}')::boolean AS staff_only
FROM
    inventory_instances AS instances
    CROSS JOIN LATERAL jsonb_array_elements((data #> '{notes}')::jsonb) AS notes (data)
    LEFT JOIN inventory_instance_note_types AS instance_note_types
        ON (notes.data #>> '{instanceNoteTypeId}')::uuid = instance_note_types.id::uuid;

