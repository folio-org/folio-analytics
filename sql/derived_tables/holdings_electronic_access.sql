DROP TABLE IF EXISTS local.holdings_electronic_access;

-- Create table for electronic access points for holdings records
CREATE TABLE local.holdings_electronic_access AS
SELECT
    holdings.id AS hol_id,
    holdings.hrid AS hold_hrid,
    json_extract_path_text(electronic_access.data, 'linkText') AS hol_link_text,
    json_extract_path_text(electronic_access.data, 'materialsSpecification') AS hol_materials_specification,
    json_extract_path_text(electronic_access.data, 'publicNote') AS hol_public_note,
    json_extract_path_text(electronic_access.data, 'relationshipId') AS hol_elec_access_relationship_id,
    inventory_electronic_access_relationships.name AS hol_elec_access_relationship_name,
    json_extract_path_text(electronic_access.data, 'uri') AS hol_uri
FROM
    inventory_holdings AS holdings
    CROSS JOIN json_array_elements(json_extract_path(data, 'electronicAccess')) AS electronic_access(data)
    LEFT JOIN inventory_electronic_access_relationships ON json_extract_path_text(electronic_access.data, 'relationshipId') = inventory_electronic_access_relationships.id;

CREATE INDEX ON local.holdings_electronic_access (hol_id);

CREATE INDEX ON local.holdings_electronic_access (hol_hrid);

CREATE INDEX ON local.holdings_electronic_access (hol_link_text);

CREATE INDEX ON local.holdings_electronic_access (hol_materials_specification);

CREATE INDEX ON local.holdings_electronic_access (hol_public_note);

CREATE INDEX ON local.holdings_electronic_access (hol_elec_access_relationship_id);

CREATE INDEX ON local.holdings_electronic_access (hol_elec_access_relationship_name);

CREATE INDEX ON local.holdings_electronic_access (hol_uri);

