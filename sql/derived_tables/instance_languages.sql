DROP TABLE IF EXISTS instance_languages;

-- Create a local table for languages in instance records.
CREATE TABLE instance_languages AS
SELECT
    instances.id AS instance_id,
    instances.hrid AS instance_hrid,
    languages.data #>> '{}' AS "language",
    languages.ordinality AS language_ordinality
FROM
    inventory_instances AS instances
    CROSS JOIN LATERAL jsonb_array_elements((data #> '{languages}')::jsonb) WITH ORDINALITY AS languages (data);

