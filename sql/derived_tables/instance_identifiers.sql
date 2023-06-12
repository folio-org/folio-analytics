DROP TABLE IF EXISTS instance_identifiers;

CREATE TABLE instance_identifiers AS
SELECT
    instances.id AS instance_id,
    instances.hrid AS instance_hrid,
    identifiers.data #>> '{identifierTypeId}' AS identifier_type_id,
    inventory_identifier_types.name AS identifier_type_name,
    identifiers.data #>> '{value}' AS identifier
FROM
    inventory_instances AS instances
    CROSS JOIN jsonb_array_elements((data #> '{identifiers}')::jsonb) AS identifiers (data)
    LEFT JOIN inventory_identifier_types ON identifiers.data #>> '{identifierTypeId}' = inventory_identifier_types.id;

