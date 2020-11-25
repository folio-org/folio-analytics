DROP TABLE IF EXISTS folio_reporting.instance_subjects;

-- Create a local table for subjects in the instance record.
CREATE TABLE folio_reporting.instance_subjects AS
SELECT
    instances.id AS instance_id,
    instances.hrid AS instance_hrid,
    json_array_elements_text(json_extract_path(instances.data, 'subjects')) AS subject
FROM
    inventory_instances AS instances;

CREATE INDEX ON folio_reporting.instance_subjects (instance_id);

CREATE INDEX ON folio_reporting.instance_subjects (instance_hrid);

CREATE INDEX ON folio_reporting.instance_subjects (subject);

