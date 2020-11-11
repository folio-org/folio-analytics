DROP TABLE IF EXISTS local.instances_languages;

CREATE TABLE local.instances_languages AS
SELECT
    instances.id AS instance_id,
    instances.hrid AS instance_hrid,
    json_array_elements_text(json_extract_path(instances.data, 'languages')) AS "language"
FROM
    inventory_instances AS instances;

CREATE INDEX ON local.instances_languages (instance_id);

CREATE INDEX ON local.instances_languages (instance_hrid);

CREATE INDEX ON local.instances_languages ("language");

