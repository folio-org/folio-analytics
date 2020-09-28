DROP TABLE IF EXISTS local.items_electronic_access;

-- Create table for electronic access points for item records
CREATE TABLE local.items_electronic_access AS
SELECT
    item.id AS itm_id,
    item.hrid AS itm_hrid,
    json_extract_path_text(electronic_access.data, 'linkText') AS itm_link_text,
    json_extract_path_text(electronic_access.data, 'materialsSpecification') AS itm_materials_specification,
    json_extract_path_text(electronic_access.data, 'publicNote') AS itm_public_note,
    json_extract_path_text(electronic_access.data, 'relationshipId') AS itm_elec_access_relationship_id,
    inventory_electronic_access_relationships.name AS itm_elec_access_relationship_name,
    json_extract_path_text(electronic_access.data, 'uri') AS itm_uri
FROM
    inventory_items AS item
    CROSS JOIN json_array_elements(json_extract_path(data, 'electronicAccess')) AS electronic_access(data)
    LEFT JOIN inventory_electronic_access_relationships ON json_extract_path_text(electronic_access.data, 'relationshipId') = inventory_electronic_access_relationships.id;

CREATE INDEX ON local.items_electronic_access (itm_id);

CREATE INDEX ON local.items_electronic_access (itm_hrid);

CREATE INDEX ON local.items_electronic_access (itm_link_text);

CREATE INDEX ON local.items_electronic_access (itm_materials_specification);

CREATE INDEX ON local.items_electronic_access (itm_public_note);

CREATE INDEX ON local.items_electronic_access (itm_elec_access_relationship_id);

CREATE INDEX ON local.items_electronic_access (itm_elec_access_relationship_name);

CREATE INDEX ON local.items_electronic_access (itm_uri);

VACUUM local.items_electronic_access;

ANALYZE local.items_electronic_access;

