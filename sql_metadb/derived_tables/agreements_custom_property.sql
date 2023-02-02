--metadb:table agreements_custom_property

--Creates a derived table on agreements custom properties.

DROP TABLE IF EXISTS agreements_custom_property;

CREATE TABLE agreements_custom_property AS
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

CREATE INDEX ON agreements_custom_property (custom_property_container_id);

CREATE INDEX ON agreements_custom_property (custom_property_id);

CREATE INDEX ON agreements_custom_property (custom_property_note);

CREATE INDEX ON agreements_custom_property (custom_property_public_note);

CREATE INDEX ON agreements_custom_property (custom_property_definition_uuid);

CREATE INDEX ON agreements_custom_property (custom_property_definition_pd_name);

CREATE INDEX ON agreements_custom_property (custom_property_definition_pd_type);

CREATE INDEX ON agreements_custom_property (custom_property_definition_pd_description);

CREATE INDEX ON agreements_custom_property (custom_property_definition_pd_label);

CREATE INDEX ON agreements_custom_property (custom_property_integer_id);

CREATE INDEX ON agreements_custom_property (custom_property_integer_value);

CREATE INDEX ON agreements_custom_property (custom_property_text_id);

CREATE INDEX ON agreements_custom_property (custom_property_text_value);

COMMENT ON COLUMN agreements_custom_property.custom_property_container_id IS 'Container ID of the custom property. The ID can be linked to the custom_properties_id attribute in the folio_agreements.subscription_agreement table';

COMMENT ON COLUMN agreements_custom_property.custom_property_id IS 'ID of the custom property';

COMMENT ON COLUMN agreements_custom_property.custom_property_note IS 'Internal note to the custom property, that displays internally to FOLIO users';

COMMENT ON COLUMN agreements_custom_property.custom_property_public_note IS 'Public note to the custom property, that displays externally to the public';

COMMENT ON COLUMN agreements_custom_property.custom_property_definition_uuid IS 'ID of the custom property definition';

COMMENT ON COLUMN agreements_custom_property.custom_property_definition_pd_name IS 'Name of the custom property definition';

COMMENT ON COLUMN agreements_custom_property.custom_property_definition_pd_type IS 'Type of the custom property definition';

COMMENT ON COLUMN agreements_custom_property.custom_property_definition_pd_description IS 'Further explanation of the property';

COMMENT ON COLUMN agreements_custom_property.custom_property_definition_pd_label IS 'The property name that appears when displaying the property to users in FOLIO';

COMMENT ON COLUMN agreements_custom_property.custom_property_integer_id IS 'ID of the integer value';

COMMENT ON COLUMN agreements_custom_property.custom_property_integer_value IS 'Value of the integer, that was entered';

COMMENT ON COLUMN agreements_custom_property.custom_property_text_id IS 'ID of the text value';

COMMENT ON COLUMN agreements_custom_property.custom_property_text_value IS 'Value of the text value, that was entered';

VACUUM ANALYZE agreements_custom_property;
