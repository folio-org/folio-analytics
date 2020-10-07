DROP TABLE IF EXISTS local.instances_publication;

-- Create table for publication information that includes publication date, place, and publisher name from instance records
CREATE TABLE local.instances_publication AS

SELECT
    instance.id AS inst_id,
    instance.hrid AS inst_hrid,
    json_extract_path_text(publication.data, 'dateOfPublication') AS inst_pub_date,
    json_extract_path_text(publication.DATA, 'place') AS inst_pub_place,
    json_extract_path_text(publication.DATA, 'publisher') AS inst_pub_publisher
FROM
    inventory_instances AS instance
    CROSS JOIN json_array_elements(json_extract_path(instance.data, 'publication')) AS publication(data);

CREATE INDEX ON local.instances_publication (inst_id);

CREATE INDEX ON local.instances_publication (inst_hrid);

CREATE INDEX ON local.instances_publication (inst_pub_date);

CREATE INDEX ON local.instances_publication (inst_pub_place);

CREATE INDEX ON local.instances_publication (inst_pub_publisher);

