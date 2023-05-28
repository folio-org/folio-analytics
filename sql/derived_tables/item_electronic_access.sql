DROP TABLE IF EXISTS item_electronic_access;

-- Create table for electronic access points for item records. This includes the name of the relationship and the id.
CREATE TABLE item_electronic_access AS
SELECT
    item.id AS item_id,
    item.hrid AS item_hrid,
    json_extract_path_text(electronic_access.data, 'linkText') AS link_text,
    json_extract_path_text(electronic_access.data, 'materialsSpecification') AS materials_specification,
    json_extract_path_text(electronic_access.data, 'publicNote') AS public_note,
    json_extract_path_text(electronic_access.data, 'relationshipId') AS relationship_id,
    inventory_electronic_access_relationships.name AS relationship_name,
    json_extract_path_text(electronic_access.data, 'uri') AS uri
FROM
    inventory_items AS item
    CROSS JOIN json_array_elements(json_extract_path(data, 'electronicAccess')) AS electronic_access(data)
    LEFT JOIN inventory_electronic_access_relationships ON json_extract_path_text(electronic_access.data, 'relationshipId') = inventory_electronic_access_relationships.id;

