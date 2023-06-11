DROP TABLE IF EXISTS instance_editions;

CREATE TABLE instance_editions AS
SELECT
    instances.id AS instance_id,
    instances.hrid AS instance_hrid,
    editions.data #>> '{}' AS edition,
    editions.ordinality AS edition_ordinality
FROM
    inventory_instances AS instances
    CROSS JOIN LATERAL jsonb_array_elements((data #> '{editions}')::jsonb)
    WITH ORDINALITY AS editions (data);

