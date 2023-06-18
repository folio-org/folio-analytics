DROP TABLE IF EXISTS instance_alternative_titles;

-- Create a derived table for alternative titles from instance records with the type id and name included.
CREATE TABLE instance_alternative_titles AS
SELECT
    instance.id AS instance_id,
    instance.hrid AS instance_hrid,
    alternative_titles.data #>> '{alternativeTitle}' AS alternative_title,
    alternative_titles.data #>> '{alternativeTitleTypeId}' AS alternative_title_type_id,
    inventory_alternative_title_types.name AS alternative_title_type_name
FROM
    inventory_instances AS instance
    CROSS JOIN jsonb_array_elements((instance.data #> '{alternativeTitles}')::jsonb) AS alternative_titles(data)
    LEFT JOIN inventory_alternative_title_types ON (alternative_titles.data #>> '{alternativeTitleTypeId}'):uuid = inventory_alternative_title_types.id;

