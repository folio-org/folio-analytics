DROP TABLE IF EXISTS instance_editions;

CREATE TABLE instance_editions AS
SELECT
    instances.id AS instance_id,
    instances.hrid AS instance_hrid,
    editions.data #>> '{}' AS edition,
    editions.ordinality AS edition_ordinality
FROM
    inventory_instances AS instances
    CROSS JOIN LATERAL json_array_elements(json_extract_path(data, 'editions'))
    WITH ORDINALITY AS editions (data);

CREATE INDEX ON instance_editions (instance_id);

CREATE INDEX ON instance_editions (instance_hrid);

CREATE INDEX ON instance_editions (edition);

CREATE INDEX ON instance_editions (edition_ordinality);

