DROP TABLE IF EXISTS local.inventory_instance_relationships_ext;

-- Create a local table that includes the name for the relationship type

CREATE TABLE local.inventory_instance_relationships_ext AS
SELECT
	relationships.id AS relationships_id,
	types.name AS relationship_type_name,
	relationships.sub_instance_id,
	relationships.super_instance_id
FROM
	inventory_instance_relationships AS relationships

LEFT JOIN inventory_instance_relationship_types AS types
    ON types.id = relationships.instance_relationship_type_id;

CREATE INDEX ON local.inventory_instance_relationships_ext (relationships_id);

CREATE INDEX ON local.inventory_instance_relationships_ext (relationship_type_name);

CREATE INDEX ON local.inventory_instance_relationships_ext (sub_instance_id);

CREATE INDEX ON local.inventory_instance_relationships_ext (super_instance_id);

VACUUM ANALYZE local.inventory_instance_relationships_ext;