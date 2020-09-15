DROP TABLE IF EXISTS local.instances_publication;

-- Create table for publication information that includes publication
-- date, place, and publisher name from instance records
CREATE TABLE local.instances_publication AS
WITH publication AS (
    SELECT
        id AS instance_id,
        hrid AS instance_hrid,
        json_extract_path_text(json_array_elements(json_extract_path(data, 'publication')), 'dateOfPublication') AS publication_date,
        json_extract_path_text(json_array_elements(json_extract_path(data, 'publication')), 'place') AS publication_place,
        json_extract_path_text(json_array_elements(json_extract_path(data, 'publication')), 'publisher') AS publication_publisher
    FROM
        inventory_instances
)
SELECT
    instance_id,
    instance_hrid,
    publication_date,
    publication_place,
    publication_publisher
FROM
    publication;

CREATE INDEX ON local.instances_publication (instance_id);

CREATE INDEX ON local.instances_publication (instance_hrid);

CREATE INDEX ON local.instances_publication (publication_date);

CREATE INDEX ON local.instances_publication (publication_place);

CREATE INDEX ON local.instances_publication (publication_publisher);

VACUUM local.instances_publication;

ANALYZE local.instances_publication;

