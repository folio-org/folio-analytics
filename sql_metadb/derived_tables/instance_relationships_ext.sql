DROP TABLE IF EXISTS instance_relationships_ext;

-- Create a local table that includes the name and id for the relationship type
CREATE TABLE instance_relationships_ext AS
SELECT
    r.id AS relationship_id,
    r.instancerelationshiptypeid AS relationship_type_id,
    t.name AS relationship_type_name,
    r.subinstanceid AS relationship_sub_instance_id,
    r.superinstanceid AS relationship_super_instance_id
FROM
    folio_inventory.instance_relationship AS r
    LEFT JOIN folio_inventory.instance_relationship_type__t AS t
        ON t.id = r.instancerelationshiptypeid;

CREATE INDEX ON instance_relationships_ext (relationship_id);

CREATE INDEX ON instance_relationships_ext (relationship_type_id);

CREATE INDEX ON instance_relationships_ext (relationship_type_name);

CREATE INDEX ON instance_relationships_ext (relationship_sub_instance_id);

CREATE INDEX ON instance_relationships_ext (relationship_super_instance_id);

VACUUM ANALYZE instance_relationships_ext;
