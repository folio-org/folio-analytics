--metadb:table instance_ext

-- Create an extended version of the instance table where the names for identifiers are included
-- This derived table doesn't include all the properties extracted from the json objects
-- For example, electronic access, notes, publication, series, or edition statements have their own
-- derived tables.

DROP TABLE IF EXISTS instance_ext;

CREATE TABLE instance_ext AS
SELECT
    i.id AS instance_id,
    jsonb_extract_path_text(i.jsonb, 'hrid') AS instance_hrid,
    jsonb_extract_path_text(i.jsonb, 'matchKey') AS match_key,
    jsonb_extract_path_text(i.jsonb, 'source') AS record_source,
    jsonb_extract_path_text(i.jsonb, 'discoverySuppress')::boolean AS discovery_suppress,
    jsonb_extract_path_text(i.jsonb, 'staffSuppress')::boolean AS staff_suppress,
    jsonb_extract_path_text(i.jsonb, 'previouslyHeld')::boolean AS previously_held,
    jsonb_extract_path_text(i.jsonb, 'isBoundWith')::boolean AS is_bound_with,
    jsonb_extract_path_text(i.jsonb, 'instanceTypeId')::uuid AS instance_type_id,
    itt.name AS instance_type_name,
    jsonb_extract_path_text(i.jsonb, 'title') AS title,
    jsonb_extract_path_text(i.jsonb, 'indexTitle') AS index_title,
    jsonb_extract_path_text(i.jsonb, 'modeOfIssuanceId')::uuid AS mode_of_issuance_id,
    moit.name AS mode_of_issuance_name,
    jsonb_extract_path_text(i.jsonb, 'catalogedDate')::date AS cataloged_date,
    jsonb_extract_path_text(i.jsonb, 'metadata', 'createdDate')::timestamptz AS created_date,
    jsonb_extract_path_text(i.jsonb, 'metadata', 'updatedDate')::timestamptz AS updated_date
FROM
    folio_inventory.instance AS i
    LEFT JOIN folio_inventory.mode_of_issuance__t AS moit ON jsonb_extract_path_text(i.jsonb, 'modeOfIssuanceId')::uuid = moit.id
    LEFT JOIN folio_inventory.instance_type__t AS itt ON jsonb_extract_path_text(i.jsonb, 'instanceTypeId')::uuid = itt.id;

CREATE INDEX ON instance_ext (instance_id);

CREATE INDEX ON instance_ext (instance_hrid);

CREATE INDEX ON instance_ext (match_key);

CREATE INDEX ON instance_ext (record_source);

CREATE INDEX ON instance_ext (discovery_suppress);

CREATE INDEX ON instance_ext (staff_suppress);

CREATE INDEX ON instance_ext (previously_held);

CREATE INDEX ON instance_ext (is_bound_with);

CREATE INDEX ON instance_ext (instance_type_id);

CREATE INDEX ON instance_ext (instance_type_name);

CREATE INDEX ON instance_ext (mode_of_issuance_id);

CREATE INDEX ON instance_ext (mode_of_issuance_name);

CREATE INDEX ON instance_ext (cataloged_date);

CREATE INDEX ON instance_ext (created_date);

CREATE INDEX ON instance_ext (updated_date);


