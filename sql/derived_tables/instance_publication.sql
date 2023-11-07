DROP TABLE IF EXISTS instance_publication;

-- Create table for publication information that includes publication date, place, publisher name, publication role and 
-- publication ordinality from instance records
CREATE TABLE instance_publication AS
SELECT
    instance.id AS instance_id,
    instance.hrid AS instance_hrid,
    publication.data #>> '{dateOfPublication}' AS date_of_publication,
    publication.data #>> '{place}' AS place,
    publication.data #>> '{publisher}' AS publisher,
    publication.data #>> '{role}' AS publication_role,
    publication.ordinality AS publication_ordinality
FROM
    inventory_instances AS instance
    CROSS JOIN jsonb_array_elements((instance.data #> '{publication}')::jsonb) WITH ORDINALITY AS publication(data);

COMMENT ON COLUMN instance_publication.instance_id IS 'UUID of the instance record';

COMMENT ON COLUMN instance_publication.instance_hrid IS 'A human readable system-assigned sequential ID which maps to the Instance ID';

COMMENT ON COLUMN instance_publication.date_of_publication IS 'Date (year YYYY) of publication, distribution, etc.';

COMMENT ON COLUMN instance_publication.place IS 'Place of publication, distribution, etc.';

COMMENT ON COLUMN instance_publication.publisher IS 'Name of publisher, distributor, etc.';

COMMENT ON COLUMN instance_publication.publication_role IS 'The role of the publisher, distributor, etc.';

COMMENT ON COLUMN instance_publication.publication_ordinality IS 'Publication value ordinality';

