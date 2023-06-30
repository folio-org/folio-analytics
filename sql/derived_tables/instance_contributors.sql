DROP TABLE IF EXISTS instance_contributors;

-- Create a derived table for contributors from instance records
CREATE TABLE instance_contributors AS
SELECT
    instance.id AS instance_id,
    instance.hrid AS instance_hrid,
    contributors.data #>> '{contributorNameTypeId}' AS contributor_name_type_id,
    inventory_contributor_name_types.name AS contributor_name_type,
    contributors.data #>> '{contributorTypeId}' AS contributor_rdatype_id,
    inventory_contributor_types.name AS contributor_rdatype_name,
    contributors.data #>> '{contributorTypeText}' AS contributor_type_freetext,
    contributors.data #>> '{name}' AS contributor_name,
    (contributors.data #>> '{primary}')::boolean AS contributor_primary
FROM
    inventory_instances AS instance
    CROSS JOIN jsonb_array_elements((instance.data #> '{contributors}')::jsonb) AS contributors(data)
    LEFT JOIN inventory_contributor_name_types ON (contributors.data #>> '{contributorNameTypeId}')::uuid = inventory_contributor_name_types.id
    LEFT JOIN inventory_contributor_types ON (contributors.data #>> '{contributorTypeId}')::uuid = inventory_contributor_types.id;

