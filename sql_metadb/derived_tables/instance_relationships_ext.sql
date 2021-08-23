DROP TABLE IF EXISTS folio_derived.instance_relationships_ext;

-- Create a local table that includes the name and id for the relationship type
CREATE TABLE folio_derived.instance_relationships_ext AS
SELECT
    r.id AS relationship_id,
    r.instance_relationship_type_id AS relationship_type_id,
    t.name AS relationship_type_name,
    r.sub_instance_id AS relationship_sub_instance_id,
    r.super_instance_id AS relationship_super_instance_id
FROM
    folio_inventory.instance_relationship_j AS r
    LEFT JOIN folio_inventory.instance_relationship_type_j AS t
        ON t.id = r.instance_relationship_type_id;

CREATE INDEX ON folio_derived.instance_relationships_ext (relationship_id);

CREATE INDEX ON folio_derived.instance_relationships_ext (relationship_type_id);

CREATE INDEX ON folio_derived.instance_relationships_ext (relationship_type_name);

CREATE INDEX ON folio_derived.instance_relationships_ext (relationship_sub_instance_id);

CREATE INDEX ON folio_derived.instance_relationships_ext (relationship_super_instance_id);

