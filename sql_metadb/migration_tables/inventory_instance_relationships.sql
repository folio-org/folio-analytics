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

ALTER TABLE inventory_instance_relationships ADD PRIMARY KEY (id);

CREATE INDEX ON inventory_instance_relationships (instance_relationship_type_id);

CREATE INDEX ON inventory_instance_relationships (sub_instance_id);

CREATE INDEX ON inventory_instance_relationships (super_instance_id);

