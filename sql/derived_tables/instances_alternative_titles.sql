DROP TABLE IF EXISTS local.instances_alternative_titles;

-- Create a derived table for alternative titles from instance records
CREATE TABLE local.instances_alternative_titles AS
SELECT
    instance.id AS ins_id,
    instance.hrid AS ins_hrid,
    json_extract_path_text(alternative_titles.data, 'alternativeTitle') AS ins_alternative_title,
    json_extract_path_text(alternative_titles.data, 'alternativeTitleTypeId') AS ins_alternative_title_type_id,
    inventory_alternative_title_types.name AS ins_alternative_title_types_name
FROM
    inventory_instances AS instance
    CROSS JOIN json_array_elements(json_extract_path(instance.data, 'alternativeTitles')) AS alternative_titles(data)
    LEFT JOIN inventory_alternative_title_types ON json_extract_path_text(alternative_titles.data, 'alternativeTitleTypeId') = inventory_alternative_title_types.id;

CREATE INDEX ON local.instances_alternative_titles (ins_id);

CREATE INDEX ON local.instances_alternative_titles (ins_hrid);

CREATE INDEX ON local.instances_alternative_titles (ins_alternative_title);

CREATE INDEX ON local.instances_alternative_titles (ins_alternative_title_type_id);

CREATE INDEX ON local.instances_alternative_titles (ins_alternative_title_types_name);

