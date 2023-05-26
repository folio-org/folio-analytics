DROP TABLE IF EXISTS organization_interfaces;

CREATE TABLE organization_interfaces AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'available')::boolean AS available,
    jsonb_extract_path_text(jsonb, 'deliveryMethod')::varchar(65535) AS delivery_method,
    jsonb_extract_path_text(jsonb, 'locallyStored')::varchar(65535) AS locally_stored,
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_extract_path_text(jsonb, 'notes')::varchar(65535) AS notes,
    jsonb_extract_path_text(jsonb, 'onlineLocation')::varchar(65535) AS online_location,
    jsonb_extract_path_text(jsonb, 'statisticsFormat')::varchar(65535) AS statistics_format,
    jsonb_extract_path_text(jsonb, 'statisticsNotes')::varchar(65535) AS statistics_notes,
    jsonb_extract_path_text(jsonb, 'uri')::varchar(65535) AS uri,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_organizations.interfaces;

