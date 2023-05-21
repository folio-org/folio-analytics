--metadb:table instance_editions

-- Create derived table for instance edition statements

DROP TABLE IF EXISTS instance_editions;

CREATE TABLE instance_editions AS
SELECT
    instances.id AS instance_id,
    jsonb_extract_path_text(instances.jsonb, 'hrid') AS instance_hrid,
    editions.jsonb #>> '{}' AS edition,
    editions.ordinality AS edition_ordinality
FROM
    folio_inventory.instance AS instances
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(instances.jsonb, 'editions')) WITH ORDINALITY AS editions (jsonb);

CREATE INDEX ON instance_editions (instance_id);

CREATE INDEX ON instance_editions (instance_hrid);

CREATE INDEX ON instance_editions (edition);

CREATE INDEX ON instance_editions (edition_ordinality);


