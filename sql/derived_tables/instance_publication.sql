DROP TABLE IF EXISTS instance_publication;

-- Create table for publication information that includes publication date, place, and publisher name from instance records
CREATE TABLE instance_publication AS
SELECT
    instance.id AS instance_id,
    instance.hrid AS instance_hrid,
    publication.data->>'dateOfPublication' AS date_of_publication,
    publication.data->>'place' AS place,
    publication.data->>'publisher' AS publisher
FROM
    inventory_instances AS instance
    CROSS JOIN jsonb_array_elements((instance.data->'publication')::jsonb) AS publication(data);

