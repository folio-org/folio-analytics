DROP TABLE IF EXISTS local.instances_subjects;

CREATE TABLE local.instances_subjects AS
SELECT
    instances.id AS instance_id,
    instances.hrid AS instance_hrid,
    json_array_elements_text(json_extract_path(instances.data, 'subjects')) AS subject
FROM
    inventory_instances AS instances;

CREATE INDEX ON local.instances_subjects (instance_id);

CREATE INDEX ON local.instances_subjects (instance_hrid);

CREATE INDEX ON local.instances_subjects (subject);

VACUUM local.instances_subjects;

ANALYZE local.instances_subjects;

