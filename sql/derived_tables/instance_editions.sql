DROP TABLE IF EXISTS folio_reporting.instance_editions;

CREATE TABLE folio_reporting.instance_editions AS
SELECT
    instances.id AS instance_id,
    instances.hrid AS instance_hrid,
    json_array_elements_text(json_extract_path(instances.data, 'editions')) AS edition
FROM
    inventory_instances AS instances;

CREATE INDEX ON folio_reporting.instance_editions (instance_id);

CREATE INDEX ON folio_reporting.instance_editions (instance_hrid);

CREATE INDEX ON folio_reporting.instance_editions (edition);

