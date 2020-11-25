DROP TABLE IF EXISTS folio_reporting.instance_languages;

--Create a local table for languages in instance records.
CREATE TABLE folio_reporting.instance_languages AS
SELECT
    instances.id AS instance_id,
    instances.hrid AS instance_hrid,
    json_array_elements_text(json_extract_path(instances.data, 'languages')) AS "language"
FROM
    inventory_instances AS instances;

CREATE INDEX ON folio_reporting.instance_languages (instance_id);

CREATE INDEX ON folio_reporting.instance_languages (instance_hrid);

CREATE INDEX ON folio_reporting.instance_languages ("language");

