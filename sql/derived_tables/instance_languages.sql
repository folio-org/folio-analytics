DROP TABLE IF EXISTS local.instance_languages;

--Create a local table for languages in instance records.
CREATE TABLE local.instance_languages AS
SELECT
    instances.id AS instance_id,
    instances.hrid AS instance_hrid,
    json_array_elements_text(json_extract_path(instances.data, 'languages')) AS "language"
FROM
    inventory_instances AS instances;

CREATE INDEX ON local.instance_languages (instance_id);

CREATE INDEX ON local.instance_languages (instance_hrid);

CREATE INDEX ON local.instance_languages ("language");

