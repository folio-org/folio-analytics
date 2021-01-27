-- Build identifiers table
CREATE TABLE local.instances_identifiers AS
    SELECT id AS instances_id,
           json_extract_path_text(
               json_array_elements(json_extract_path(data, 'identifiers')),
                                   'identifierTypeId' ) AS type_id,
           json_extract_path_text(
               json_array_elements(json_extract_path(data, 'identifiers')),
                                   'value' ) AS value
        FROM local.instances;
CREATE INDEX ON local.instances_identifiers (instances_id);
CREATE INDEX ON local.instances_identifiers (type_id);
CREATE INDEX ON local.instances_identifiers (value);
VACUUM local.instances_identifiers;
ANALYZE local.instances_identifiers;
