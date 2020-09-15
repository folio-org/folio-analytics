DROP TABLE IF EXISTS local.instances_electronic_access;

-- Create table for electronic access points for instance records
CREATE TABLE local.instances_electronic_access AS
WITH instances_relationship_ids AS (
    SELECT
        instance.id AS instance_id,
        instance.hrid AS instance_hrid,
        json_extract_path_text(json_array_elements(json_extract_path(instance.data, 'electronicAccess')), 'linkText') ::varchar AS electronic_access_link_text,
        json_extract_path_text(json_array_elements(json_extract_path(instance.data, 'electronicAccess')), 'materialsSpecification') ::varchar AS electronic_access_materials_specification,
        json_extract_path_text(json_array_elements(json_extract_path(instance.data, 'electronicAccess')), 'publicNote') ::varchar AS electronic_access_public_note,
        json_extract_path_text(json_array_elements(json_extract_path(instance.data, 'electronicAccess')), 'relationshipId') ::varchar AS electronic_access_relationship_id,
        json_extract_path_text(json_array_elements(json_extract_path(instance.data, 'electronicAccess')), 'uri') ::varchar AS electronic_access_uri
    FROM
        inventory_instances AS instance
)
SELECT
    instances_relationship_ids.instance_id,
    instances_relationship_ids.instance_hrid,
    instances_relationship_ids.electronic_access_link_text,
    instances_relationship_ids.electronic_access_materials_specification,
    instances_relationship_ids.electronic_access_public_note,
    instances_relationship_ids.electronic_access_relationship_id,
    inventory_electronic_access_relationships.name AS electronic_access_relationship_id_name,
    instances_relationship_ids.electronic_access_uri
FROM
    instances_relationship_ids
    LEFT JOIN inventory_electronic_access_relationships ON instances_relationship_ids.electronic_access_relationship_id = inventory_electronic_access_relationships.id;

CREATE INDEX ON local.instances_electronic_access (instance_id);

CREATE INDEX ON local.instances_electronic_access (instance_hrid);

CREATE INDEX ON local.instances_electronic_access (electronic_access_link_text);

CREATE INDEX ON local.instances_electronic_access (electronic_access_materials_specification);

CREATE INDEX ON local.instances_electronic_access (electronic_access_public_note);

CREATE INDEX ON local.instances_electronic_access (electronic_access_relationship_id);

CREATE INDEX ON local.instances_electronic_access (electronic_access_relationship_id_name);

CREATE INDEX ON local.instances_electronic_access (electronic_access_uri);

VACUUM ANALYZE local.instances_electronic_access;

