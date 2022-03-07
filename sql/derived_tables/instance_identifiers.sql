DROP TABLE IF EXISTS instance_identifiers;

CREATE TABLE instance_identifiers AS
SELECT
    instances.id AS instance_id,
    instances.hrid AS instance_hrid,
    json_extract_path_text(identifiers.data, 'identifierTypeId') AS identifier_type_id,
    inventory_identifier_types.name AS identifier_type_name,
    json_extract_path_text(identifiers.data, 'value') AS identifier
FROM
    inventory_instances AS instances
    CROSS JOIN json_array_elements(json_extract_path(data, 'identifiers')) AS identifiers (data)
    LEFT JOIN inventory_identifier_types ON json_extract_path_text(identifiers.data, 'identifierTypeId') = inventory_identifier_types.id;

CREATE INDEX ON instance_identifiers (instance_id);

CREATE INDEX ON instance_identifiers (instance_hrid);

CREATE INDEX ON instance_identifiers (identifier_type_id);

CREATE INDEX ON instance_identifiers (identifier_type_name);

CREATE INDEX ON instance_identifiers (identifier);

VACUUM ANALYZE instance_identifiers;

