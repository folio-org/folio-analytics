-- Create a derived table for subjects in the instance record.

DROP TABLE IF EXISTS instance_subjects;

CREATE TABLE instance_subjects AS
SELECT
    instances.id AS instance_id,
    instances.hrid AS instance_hrid,
    json_extract_path_text(subjects.data, 'value') AS subject,
    subjects.ordinality AS subject_ordinality
FROM
    inventory_instances AS instances
   CROSS JOIN json_array_elements(json_extract_path(instances.data, 'subjects'))
   WITH ORDINALITY AS subjects (data);
   
CREATE INDEX ON instance_subjects (instance_id);

CREATE INDEX ON instance_subjects (instance_hrid);

CREATE INDEX ON instance_subjects (subject);

CREATE INDEX ON instance_subjects (subject_ordinality);

VACUUM ANALYZE instance_subjects;

COMMENT ON COLUMN instance_subjects.instance_id IS 'UUID of the instance record';

COMMENT ON COLUMN instance_subjects.instance_hrid IS 'A human readable system-assigned sequential ID which maps to the Instance ID';

COMMENT ON COLUMN instance_subjects.subject IS 'Subject heading value';

COMMENT ON COLUMN instance_subjects.subject_ordinality IS 'Subject heading value ordinality';
