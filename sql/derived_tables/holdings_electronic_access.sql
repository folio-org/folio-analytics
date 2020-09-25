DROP TABLE IF EXISTS local.holdings_electronic_access;

-- Create table for electronic access points for holdings records
CREATE TABLE local.holdings_electronic_access AS
SELECT
    holdings.id AS holdings_id,
    holdings.hrid AS holdings_hrid,
    json_extract_path_text(electronic_access.data, 'linkText') AS link_text,
    json_extract_path_text(electronic_access.data, 'materialsSpecification') AS materials_specification,
    json_extract_path_text(electronic_access.data, 'publicNote') AS public_note,
    json_extract_path_text(electronic_access.data, 'relationshipId') AS relationship_id,
    inventory_instance_relationship_types.name AS relationship_type_id_name,
    json_extract_path_text(electronic_access.data, 'uri') AS uri
FROM
    inventory_holdings AS holdings
    CROSS JOIN json_array_elements(json_extract_path(data, 'electronicAccess')) AS electronic_access(data)
    LEFT JOIN inventory_instance_relationship_types ON json_extract_path_text(electronic_access.data, 'relationshipId') = inventory_instance_relationship_types.id;

CREATE INDEX ON local.holdings_electronic_access (holdings_id);

CREATE INDEX ON local.holdings_electronic_access (holdings_hrid);

CREATE INDEX ON local.holdings_electronic_access (link_text);

CREATE INDEX ON local.holdings_electronic_access (materials_specification);

CREATE INDEX ON local.holdings_electronic_access (public_note);

CREATE INDEX ON local.holdings_electronic_access (relationship_id);

CREATE INDEX ON local.holdings_electronic_access (relationship_type_id_name);

CREATE INDEX ON local.holdings_electronic_access (uri);

VACUUM local.holdings_electronic_access;

ANALYZE local.holdings_electronic_access;

