DROP TABLE IF EXISTS local.holdings_electronic_access;

-- Create table for electronic access points for holdings records
CREATE TABLE local.holdings_electronic_access AS
WITH holdings_relationship_ids AS (
    SELECT
        holdings.id AS holdings_id,
        holdings.hrid AS holdings_hrid,
        json_extract_path_text(json_array_elements(json_extract_path(holdings.data, 'electronicAccess')), 'linkText') AS electronic_access_link_text,
        json_extract_path_text(json_array_elements(json_extract_path(holdings.data, 'electronicAccess')), 'materialsSpecification') AS electronic_access_materials_specification,
        json_extract_path_text(json_array_elements(json_extract_path(holdings.data, 'electronicAccess')), 'publicNote') AS electronic_access_public_note,
        json_extract_path_text(json_array_elements(json_extract_path(holdings.data, 'electronicAccess')), 'relationshipId') AS electronic_access_relationship_id,
        json_extract_path_text(json_array_elements(json_extract_path(holdings.data, 'electronicAccess')), 'uri') AS electronic_access_uri
    FROM
        inventory_holdings AS holdings
)
SELECT
    holdings_relationship_ids.holdings_id,
    holdings_relationship_ids.holdings_hrid,
    holdings_relationship_ids.electronic_access_link_text,
    holdings_relationship_ids.electronic_access_materials_specification,
    holdings_relationship_ids.electronic_access_public_note,
    holdings_relationship_ids.electronic_access_relationship_id,
    inventory_electronic_access_relationships.name AS electronic_access_relationship_id_name,
    holdings_relationship_ids.electronic_access_uri
FROM
    holdings_relationship_ids
    LEFT JOIN inventory_electronic_access_relationships ON holdings_relationship_ids.electronic_access_relationship_id = inventory_electronic_access_relationships.id;

CREATE INDEX ON local.holdings_electronic_access (holdings_id);

CREATE INDEX ON local.holdings_electronic_access (holdings_hrid);

CREATE INDEX ON local.holdings_electronic_access (electronic_access_link_text);

CREATE INDEX ON local.holdings_electronic_access (electronic_access_materials_specification);

CREATE INDEX ON local.holdings_electronic_access (electronic_access_public_note);

CREATE INDEX ON local.holdings_electronic_access (electronic_access_relationship_id);

CREATE INDEX ON local.holdings_electronic_access (electronic_access_relationship_id_name);

CREATE INDEX ON local.holdings_electronic_access (electronic_access_uri);

VACUUM ANALYZE local.holdings_electronic_access;

