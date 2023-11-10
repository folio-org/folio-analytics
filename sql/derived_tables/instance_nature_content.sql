DROP TABLE IF EXISTS instance_nature_content;

CREATE TABLE instance_nature_content AS
WITH nature_content AS (
    SELECT
        id AS instance_id,
        hrid AS instance_hrid,
        (nature_of_content_term_ids.data #>> '{}')::uuid AS nature_of_content_term_id
    FROM
        inventory_instances
        CROSS JOIN jsonb_array_elements((data #> '{natureOfContentTermIds}')::jsonb) AS nature_of_content_term_ids (data)
)
SELECT
    nature_content.instance_id,
    nature_content.instance_hrid,
    nature_content.nature_of_content_term_id,
    nature_content_term.name AS nature_of_content_term_name,
    nature_content_term.source AS nature_of_content_term_source
FROM
    nature_content
    JOIN inventory_nature_of_content_terms AS nature_content_term
        ON nature_content_term.id::uuid = nature_content.nature_of_content_term_id;

