DROP TABLE IF EXISTS instance_electronic_access;

-- Create table for electronic access points for instance records that includes the relationship id and name.
CREATE TABLE instance_electronic_access AS
SELECT
    instance.id AS instance_id,
    instance.hrid AS instance_hrid,
    electronic_access.data #>> '{linkText}' AS link_text,
    electronic_access.data #>> '{materialsSpecification}' AS materials_specification,
    electronic_access.data #>> '{publicNote}' AS public_note,
    electronic_access.data #>> '{relationshipId}' AS relationship_id,
    inventory_electronic_access_relationships.name AS relationship_name,
    electronic_access.data #>> '{uri}' AS uri
FROM
    inventory_instances AS instance
    CROSS JOIN jsonb_array_elements((data #> '{electronicAccess}')::jsonb) AS electronic_access(data)
    LEFT JOIN inventory_electronic_access_relationships ON (electronic_access.data #>> '{relationshipId}')::uuid = inventory_electronic_access_relationships.id;

