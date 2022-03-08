-- Create derived table for Instance languages

DROP TABLE IF EXISTS instance_languages;

CREATE TABLE instance_languages AS
SELECT
    instances.id AS instance_id,
    jsonb_extract_path_text(instances.jsonb, 'hrid') AS instance_hrid,
    languages.jsonb #>> '{}' AS instance_language,
    languages.ordinality AS language_ordinality
FROM
    folio_inventory.instance AS instances
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(jsonb, 'languages')) WITH ORDINALITY AS languages (jsonb);

CREATE INDEX ON instance_languages (instance_id);

CREATE INDEX ON instance_languages (instance_hrid);

CREATE INDEX ON instance_languages (instance_language);

CREATE INDEX ON instance_languages (language_ordinality);

VACUUM ANALYZE instance_languages;

