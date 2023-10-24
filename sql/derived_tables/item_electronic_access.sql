DROP TABLE IF EXISTS item_electronic_access;

-- Create table for electronic access points for item records. This includes the name of the relationship and the id.
CREATE TABLE item_electronic_access AS
SELECT
    item.id AS item_id,
    item.hrid AS item_hrid,
    electronic_access.data #>> '{linkText}' AS link_text,
    electronic_access.data #>> '{materialsSpecification}' AS materials_specification,
    electronic_access.data #>> '{publicNote}' AS public_note,
    electronic_access.data #>> '{relationshipId}' AS relationship_id,
    inventory_electronic_access_relationships.name AS relationship_name,
    electronic_access.data #>> '{uri}' AS uri
FROM
    inventory_items AS item
    CROSS JOIN jsonb_array_elements((data #> '{electronicAccess}')::jsonb) AS electronic_access(data)
    LEFT JOIN inventory_electronic_access_relationships
        ON (electronic_access.data #>> '{relationshipId}')::uuid = inventory_electronic_access_relationships.id::uuid;

