DROP TABLE IF EXISTS local.items_electronic_access;

-- Create table for electronic access points for item records
CREATE TABLE local.items_electronic_access AS
WITH items_relationship_ids AS (
    SELECT
        item.id AS item_id,
        item.hrid AS item_hrid,
        json_extract_path_text(json_array_elements(json_extract_path(item.data, 'electronicAccess')), 'linkText') AS electronic_access_link_text,
        json_extract_path_text(json_array_elements(json_extract_path(item.data, 'electronicAccess')), 'materialsSpecification') AS electronic_access_materials_specification,
        json_extract_path_text(json_array_elements(json_extract_path(item.data, 'electronicAccess')), 'publicNote') AS electronic_access_public_note,
        json_extract_path_text(json_array_elements(json_extract_path(item.data, 'electronicAccess')), 'relationshipId') AS electronic_access_relationship_id,
        json_extract_path_text(json_array_elements(json_extract_path(item.data, 'electronicAccess')), 'uri') AS electronic_access_uri
    FROM
        inventory_items AS item
)
SELECT
    items_relationship_ids.item_id,
    items_relationship_ids.item_hrid,
    items_relationship_ids.electronic_access_link_text,
    items_relationship_ids.electronic_access_materials_specification,
    items_relationship_ids.electronic_access_public_note,
    items_relationship_ids.electronic_access_relationship_id,
    inventory_electronic_access_relationships.name AS electronic_access_relationship_id_name,
    items_relationship_ids.electronic_access_uri
FROM
    items_relationship_ids
    LEFT JOIN inventory_electronic_access_relationships ON items_relationship_ids.electronic_access_relationship_id = inventory_electronic_access_relationships.id;

CREATE INDEX ON local.items_electronic_access (item_id);

CREATE INDEX ON local.items_electronic_access (item_hrid);

CREATE INDEX ON local.items_electronic_access (electronic_access_link_text);

CREATE INDEX ON local.items_electronic_access (electronic_access_materials_specification);

CREATE INDEX ON local.items_electronic_access (electronic_access_public_note);

CREATE INDEX ON local.items_electronic_access (electronic_access_relationship_id);

CREATE INDEX ON local.items_electronic_access (electronic_access_relationship_id_name);

CREATE INDEX ON local.items_electronic_access (electronic_access_uri);

VACUUM local.items_electronic_access;

ANALYZE local.items_electronic_access;

