-- Create a derived table for subjects in the instance record.

DROP TABLE IF EXISTS instance_subjects;

CREATE TABLE instance_subjects AS
SELECT
    instances.id AS instance_id,
    instances.hrid AS instance_hrid,
    subjects.data #>> '{value}' AS subject,
    subjects.ordinality AS subject_ordinality
FROM
    inventory_instances AS instances
   CROSS JOIN jsonb_array_elements((instances.data #> '{subjects}')::jsonb)
   WITH ORDINALITY AS subjects (data);
   
COMMENT ON COLUMN instance_subjects.instance_id IS 'UUID of the instance record';

COMMENT ON COLUMN instance_subjects.instance_hrid IS 'A human readable system-assigned sequential ID which maps to the Instance ID';

COMMENT ON COLUMN instance_subjects.subject IS 'Subject heading value';

COMMENT ON COLUMN instance_subjects.subject_ordinality IS 'Subject heading value ordinality';
