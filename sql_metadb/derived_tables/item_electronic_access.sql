DROP TABLE IF EXISTS item_electronic_access;

-- Creates a table for electronic access points for item records. This includes the name of the relationship, id, and uri.
CREATE TABLE item_electronic_access AS
SELECT
    i__t.id AS item_id,
    i__t.hrid AS item_hrid,
    jsonb_extract_path_text(electronic_access.data, 'linkText') AS link_text,
    jsonb_extract_path_text(electronic_access.data, 'materialsSpecification') AS materials_specification,
    jsonb_extract_path_text(electronic_access.data, 'publicNote') AS public_note,
    jsonb_extract_path_text(electronic_access.data, 'relationshipId') AS relationship_id,
    ear__t.name AS relationship_name,
    jsonb_extract_path_text(electronic_access.data, 'uri') AS uri
FROM
    folio_inventory.item AS i
    CROSS JOIN jsonb_array_elements(jsonb_extract_path(jsonb, 'electronicAccess')) AS electronic_access(data)
    LEFT JOIN folio_inventory.item__t AS i__t ON i.id = i__t.id
    LEFT JOIN folio_inventory.electronic_access_relationship__t AS ear__t ON jsonb_extract_path_text(electronic_access.data, 'relationshipId')::uuid = ear__t.id
;

CREATE INDEX ON item_electronic_access (item_id);

CREATE INDEX ON item_electronic_access (item_hrid);

CREATE INDEX ON item_electronic_access (link_text);

CREATE INDEX ON item_electronic_access (materials_specification);

CREATE INDEX ON item_electronic_access (public_note);

CREATE INDEX ON item_electronic_access (relationship_id);

CREATE INDEX ON item_electronic_access (relationship_name);

CREATE INDEX ON item_electronic_access (uri);

VACUUM ANALYZE item_electronic_access;
