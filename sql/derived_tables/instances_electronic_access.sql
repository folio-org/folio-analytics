DROP TABLE IF EXISTS local.instances_electronic_access;

-- Create table for electronic access points for instance records
CREATE TABLE local.instances_electronic_access AS
SELECT
    instance.id AS ins_id,
    instance.hrid AS ins_hrid,
    json_extract_path_text(electronic_access.data, 'linkText') AS ins_link_text,
    json_extract_path_text(electronic_access.data, 'materialsSpecification') AS ins_materials_specification,
    json_extract_path_text(electronic_access.data, 'publicNote') AS ins_public_note,
    json_extract_path_text(electronic_access.data, 'relationshipId') AS ins_elec_access_relationship_id,
    inventory_electronic_access_relationships.name AS ins_elec_access_relationship_name,
    json_extract_path_text(electronic_access.data, 'uri') AS ins_uri
FROM
    inventory_instances AS instance
    CROSS JOIN json_array_elements(json_extract_path(data, 'electronicAccess')) AS electronic_access(data)
    LEFT JOIN inventory_electronic_access_relationships ON json_extract_path_text(electronic_access.data, 'relationshipId') = inventory_electronic_access_relationships.id;

CREATE INDEX ON local.instances_electronic_access (instance_id);

CREATE INDEX ON local.instances_electronic_access (instance_hrid);

CREATE INDEX ON local.instances_electronic_access (link_text);

CREATE INDEX ON local.instances_electronic_access (materials_specification);

CREATE INDEX ON local.instances_electronic_access (public_note);

CREATE INDEX ON local.instances_electronic_access (ins_elec_access_relationship_id);

CREATE INDEX ON local.instances_electronic_access (ins_elec_access_relationship_name);

CREATE INDEX ON local.instances_electronic_access (ins_uri);

