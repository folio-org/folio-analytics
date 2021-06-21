/*
 * Creates a derived table on agreements custom properties
 */
DROP TABLE IF EXISTS folio_derived.agreements_custom_property;

CREATE TABLE folio_derived.agreements_custom_property AS
SELECT
    agreements_custom_property_container.id AS custom_property_container_id, -- ID that can be linked to the "custom_properties_id" attribute in the "folio_agreements.subscription_agreement" table
    agreements_custom_property.id AS custom_property_id,
    agreements_custom_property.note AS custom_property_note,
    agreements_custom_property.public_note AS custom_property_public_note,
    agreements_custom_property_definition.pd_id AS custom_property_definition_uuid,
    agreements_custom_property_definition.pd_name AS custom_property_definition_pd_name,
    agreements_custom_property_definition.pd_type AS custom_property_definition_pd_type,
    agreements_custom_property_definition.pd_description AS custom_property_definition_pd_description,
    agreements_custom_property_definition.pd_label AS custom_property_definition_pd_label,
    agreements_custom_property_integer.id AS custom_property_integer_id,
    agreements_custom_property_integer.value AS custom_property_integer_value,
    agreements_custom_property_text.id AS custom_property_text_id,
    agreements_custom_property_text.value AS custom_property_text_value
FROM
    folio_agreements.custom_property_container AS agreements_custom_property_container
    LEFT JOIN folio_agreements.custom_property AS agreements_custom_property ON agreements_custom_property_container.id = agreements_custom_property.parent_id
    LEFT JOIN folio_agreements.custom_property_definition AS agreements_custom_property_definition ON agreements_custom_property.definition_id = agreements_custom_property_definition.pd_id
    LEFT JOIN folio_agreements.custom_property_integer AS agreements_custom_property_integer ON agreements_custom_property_integer.id = agreements_custom_property.id
    LEFT JOIN folio_agreements.custom_property_text AS agreements_custom_property_text ON agreements_custom_property_text.id = agreements_custom_property.id;

CREATE INDEX ON folio_derived.agreements_custom_property (custom_property_container_id);

CREATE INDEX ON folio_derived.agreements_custom_property (custom_property_id);

CREATE INDEX ON folio_derived.agreements_custom_property (custom_property_note);

CREATE INDEX ON folio_derived.agreements_custom_property (custom_property_public_note);

CREATE INDEX ON folio_derived.agreements_custom_property (custom_property_definition_uuid);

CREATE INDEX ON folio_derived.agreements_custom_property (custom_property_definition_pd_name);

CREATE INDEX ON folio_derived.agreements_custom_property (custom_property_definition_pd_type);

CREATE INDEX ON folio_derived.agreements_custom_property (custom_property_definition_pd_description);

CREATE INDEX ON folio_derived.agreements_custom_property (custom_property_definition_pd_label);

CREATE INDEX ON folio_derived.agreements_custom_property (custom_property_integer_id);

CREATE INDEX ON folio_derived.agreements_custom_property (custom_property_integer_value);

CREATE INDEX ON folio_derived.agreements_custom_property (custom_property_text_id);

CREATE INDEX ON folio_derived.agreements_custom_property (custom_property_text_value);
