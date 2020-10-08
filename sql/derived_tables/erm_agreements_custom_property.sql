DROP TABLE IF EXISTS local.erm_agreements_custom_property;

-- Resolving the definition name from erm_agreements_custom_property_definition

CREATE TABLE local.erm_agreements_custom_property AS
SELECT
    id AS custom_property_id,
    definition_id AS custom_property_definition_id,
    cpd.pd_name AS custom_property_definition_name,
    parent_id AS custom_property_parent_id
FROM
    erm_agreements_custom_property AS cp
    LEFT JOIN erm_agreements_custom_property_definition AS cpd ON cp.definition_id = cpd.pd_id;

CREATE INDEX ON local.erm_agreements_custom_property (custom_property_id);

CREATE INDEX ON local.erm_agreements_custom_property (custom_property_definition_id);

CREATE INDEX ON local.erm_agreements_custom_property (custom_property_definition_name);

CREATE INDEX ON local.erm_agreements_custom_property (custom_property_parent_id);

