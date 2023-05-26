DROP TABLE IF EXISTS inventory_instance_relationships;

CREATE TABLE inventory_instance_relationships AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'instanceRelationshipTypeId')::varchar(36) AS instance_relationship_type_id,
    jsonb_extract_path_text(jsonb, 'subInstanceId')::varchar(36) AS sub_instance_id,
    jsonb_extract_path_text(jsonb, 'superInstanceId')::varchar(36) AS super_instance_id,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_inventory.instance_relationship;

